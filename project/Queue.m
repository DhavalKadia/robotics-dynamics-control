classdef Queue < handle
    properties
        head
        tail
        size
    end
    
    methods
        function queue = Queue()
            temp = Interval(0, 0);
            node = Node(temp, Node.empty);
            
            queue.head = node;
            queue.tail = node;
            
            queue.size = 0;
        end
        
        function enqueue(queue, I)
            queue.tail.next = Node(I, Node.empty);
            queue.tail = queue.tail.next;
            
            queue.size = queue.size + 1;
        end
        
        function element = dequeue(queue)
            if queue.head == queue.tail
                disp("Empty queue!");
            else
                element = queue.head.next.intervals;
                
                queue.head.next = queue.head.next.next;
                
                queue.size = queue.size - 1;
                
                if isempty(queue)
                    queue.tail = queue.head;
                end
            end
        end
        
        function bool = isempty(queue)            
              if queue.size == 0
                  bool = true;
              else
                  bool = false;
              end
        end
    end
end 