classdef Node < handle
    properties
        intervals
        next
    end
    
    methods
        function node = Node(intVec, next_node)
            node.intervals = intVec;
            node.next = next_node;
        end
    end
end