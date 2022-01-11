package parser.ast;

import parser.NodeMap;
import parser.visitor.Visitable;

import java.util.ArrayList;
import java.util.List;

/*
*  AST node.
*  Disjoint extend class:
*   Exprn
*   Declaration
*   Cmd
*   Opens
*   Function/Predicate/Assert
*   Fact
*   SigDef
* */
public abstract class Node implements Visitable {

    // parent Node, root.parent = null
    public Node parent;

    // list of children
    protected List<Node> children;

    // the corresponding alloy AST node, alloyNode != null
    protected Object alloyNode;

    /* map between AST node and Alloy node and node name to object */
    public static final NodeMap nodeMap = new NodeMap();

    public Node(Node parent, Object alloyNode) {
        this.parent = parent;
        this.children = new ArrayList<>();
        this.alloyNode = alloyNode;
        nodeMap.put(this, alloyNode);
    }

    public Node(Node parent) {
        this.parent = parent;
        this.children = new ArrayList<>();
        this.alloyNode = parent == null ? null : parent.getAlloyNode();
    }

    public Node() {
        this.parent = null;
        this.children = new ArrayList<>();
        this.alloyNode = null;
    }


    public abstract void toString(StringBuilder sb);

    public Node getParent() {
        return parent;
    }

    public void setParent(Node parent) {
        this.parent = parent;
    }

    public List<Node> getChildren() {
        return children;
    }

    public void setChildren(List<Node> children) {
        this.children = children;
    }

    public Object getAlloyNode() {
        return alloyNode;
    }

    public void setAlloyNode(Object alloyNode) {
        this.alloyNode = alloyNode;
    }

    public NodeMap getNodeMap() {
        return nodeMap;
    }
}
