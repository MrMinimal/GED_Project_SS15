1. Wenn man Draw() benutzt, m�ssen die Vertices im VertexBuffer in der richtigen Reihenfolge (Dreiecke bildend) stehen. Hinzu kommt, dass man bei Draw() keinen IndexBuffer ben�tigt. Als Parameter bei der Draw() Methode muss man Draw(3,0) angeben, damit klar ist, dass 3 aufeinanderfolgende Vertices im VertexBuffer ein Dreieck bilden.

2. Siehe Mail 