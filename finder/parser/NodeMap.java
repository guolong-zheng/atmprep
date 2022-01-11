package parser;

import parser.ast.Node;

import java.util.HashMap;
import java.util.Map;

public class NodeMap {
    /*
    * AModel node to Alloy node
    * */
    Map<Node, Object> node2alloy = new HashMap<>();

    /*
    * Alloy Node to AModel node
    * */
    Map<Object, Node> alloy2node = new HashMap<>();

    /*
    *  name to func
    *  name to pred
    *  name to sigdef
    * */
    public Map<String, Node> name2node = new HashMap<>();

    public void put(Node node, Object object) {
        node2alloy.put(node, object);
        alloy2node.put(object, node);
    }

    public void put(String name, Node node) {
        name2node.put(name, node);
    }

    public void put(Node node, String name, Object object) {
        this.put(node, object);
        this.put(name, node);
    }

    public Node findFunc(String name){
        return name2node.get(name);
    }

    public Node getNodeByAlloy(Object o){
        return alloy2node.get(o);
    }
}
