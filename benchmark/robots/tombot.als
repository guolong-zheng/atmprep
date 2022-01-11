

--components

abstract sig ArmAngle, Coordinate {}

abstract sig Side{}
lone sig Left extends Side{}
lone sig Right extends Side{}

abstract sig HapticFeedback{}
one sig HapticsEnabled extends HapticFeedback{}
one sig HapticsDisabled extends HapticFeedback{}

abstract sig EffectorType{}
lone sig Cautery_Tissue_Grasper extends EffectorType{}
lone sig Cautery_Shears extends EffectorType{}
lone sig Cautery_Hook extends EffectorType{}
lone sig Tissue_Grasper extends EffectorType{}
lone sig Shears extends EffectorType{}

abstract sig PedalFunction{}
one sig ClutchButton extends PedalFunction{}
one sig HPButton extends PedalFunction{}
one sig ScaleButton extends PedalFunction{}
one sig CauteryButton extends PedalFunction{}

--each button is assigned to one function
sig PedalButton{
	assigned: one PedalFunction
}

abstract sig Plugin {}

abstract sig GeomagicTouch {
	input: one Coordinate,
	force: some HapticFeedback,
}

abstract one sig RobotApp {
	includes: some Plugin
}

abstract one sig LoadedPlugins {
	loads: some Plugin
}

abstract sig SolverFamily{
	calls: one KinematicModel
}

--specifies the solver
abstract sig KinematicModel{
	solverResult: Coordinate -> ArmAngle
}

abstract one sig Robot {
	arms: some RobotArm
}

abstract sig RobotArm{
	armside: one Side,
	armModel: one ArmType,
	effectorType: one EffectorType
}

abstract sig ArmType {
	anglelimit: set ArmAngle, //set of all the arm angles that are less than limit
	inverseKSolver: one KinematicModel
}

abstract sig RobotControl{
	output: set ArmAngle,
}

one sig Clutch_Plugin extends Plugin{}
one sig GeomagicTouch_plugin extends Plugin{}
one sig HomePosition extends Plugin{}
one sig GrasperLimits extends Plugin{}
one sig Scale extends Plugin{}
one sig DummyController extends Plugin{}
one sig ButtonInterface extends	Plugin{
	setButtonForPedal : some PedalButton
}
abstract sig SolverPlugin extends Plugin{
	solverfamily: one SolverFamily,
}

--return the angles produced from a specific coordinate
fun getArmAngles[s: KinematicModel, c: Coordinate] : one (ArmAngle) {
	s.solverResult[c]
}

--Facts.
--outputs should be in the range of solverResult
fact{
	all o: RobotControl.output | one a: getArmAngles[KinematicModel,Coordinate] | o = a
}

--There is one kinematic model for each robot arm
fact {
    all r: RobotArm | one k: ArmType | r.armModel = k
}

--The solver should be in the armtype solver set
fact {
   KinematicModel in ArmType.*inverseKSolver
}

--all coordinates belong to GMT movements
fact {
	all c: Coordinate | all g : GeomagicTouch | c in g.input
}

--for each of the c coordinates there exists an angle
--and that angle is in the solver result
fact {
	all c: Coordinate | some a: ArmAngle, s : KinematicModel| c->a in s.solverResult
}

--all Plugins belong to RobotApp
fact {
	all p: Plugin | one r: RobotApp | p in r.includes
}

--if the cautery effector is used, scale can't be used
--if the non-cautery tool is used, Grasper limits
--should be added to loads
--and Cautery button shouldn't be assigned
fact{
	(RobotArm.effectorType = Cautery_Tissue_Grasper or
	RobotArm.effectorType = Cautery_Shears or
	RobotArm.effectorType = Cautery_Hook)
	=> ScaleButton not in PedalButton.assigned &&
	CauteryButton in PedalButton.assigned &&
	GrasperLimits not in LoadedPlugins.loads &&
	Scale not in LoadedPlugins.loads
	else
	CauteryButton not in PedalButton.assigned &&
	ScaleButton in PedalButton.assigned &&
	GrasperLimits in LoadedPlugins.loads
}

fact{
	ScaleButton in PedalButton.assigned
	=> Scale in LoadedPlugins.loads
}

fact{
	ClutchButton + HPButton in PedalButton.assigned
}

fact{
	all a, b : PedalButton | a != b implies no a.assigned & b.assigned
}

fact {
	one Robot
	one ArmType
	one GeomagicTouch
	one RobotControl
	one RobotArm
	one SolverPlugin
	one SolverFamily
	some Plugin
}

fact {
	#ArmType.anglelimit > 2 //up to four
	#RobotControl.output > 1
	#PedalButton = 3
	#ButtonInterface.setButtonForPedal = 3
	#Coordinate = 1
}

pred ProduceFeedback[output : RobotControl.output] {
	output not in ArmType.anglelimit
	some notification : GeomagicTouch.force | notification = HapticsEnabled
}


--What you should get as output:
-- solverResult[Coordinate1] is equal to ArmAngle0 unless ArmAngle0 is not in anglelimit


sig armangle extends ArmAngle{}
sig xyz_input extends Coordinate{}

--plugins expected from a typical config file
one sig GeomagicTouchPlugin_instance extends GeomagicTouch_plugin{}
one sig HomePosition_instance extends HomePosition{}
one sig Clutch_instance extends Clutch_Plugin{}
one sig Kinematics_plugin extends SolverPlugin{}
one sig ButtonInterface_instance extends ButtonInterface{}

one sig loaded_plugins_of_ extends LoadedPlugins {}{
	GeomagicTouchPlugin_instance +
	HomePosition_instance +
	Clutch_instance +
	Kinematics_plugin +
	ButtonInterface_instance in loads
}

one sig SingleArmFamily extends SolverFamily{}{
	calls = TwoArmCoupledShoulder
}

one sig TwoArmCoupledShoulder extends KinematicModel{}

one sig tomBot extends ArmType{}{
	inverseKSolver = TwoArmCoupledShoulder
}

one sig tomBotArm extends RobotArm{}{
	armModel = tomBot
}

one sig UsedGeomagicTouch extends GeomagicTouch {}{
}

fact {
    HapticsDisabled in	UsedGeomagicTouch.force
}

one sig Current_Robot extends Robot {}{
	arms = tomBotArm
}

fact{
    #ArmType.anglelimit = 3
    #RobotControl.output = 3
	#solverResult = 3
}
--assert if the arm angle created by movement is in the set of armangle limit
assert repair_assert_1 {
all a: RobotControl.output | a not in ArmType.anglelimit
implies ProduceFeedback[a]
}
check repair_assert_1 for 4 but 9 Plugin

pred repair_pred_1 {
all a: RobotControl.output | a not in ArmType.anglelimit
implies ProduceFeedback[a]
}
run repair_pred_1 for 4 but 9 Plugin
