        IDENTIFICATION DIVISION.
        PROGRAM-ID. HELLO.
      
        ENVIRONMENT DIVISION.
            INPUT-OUTPUT SECTION.
                FILE-CONTROL.
                SELECT cable1 ASSIGN TO 'cable1.txt'
                ORGANIZATION IS LINE SEQUENTIAL. 
                SELECT cable2 ASSIGN TO 'cable2.txt'
                ORGANIZATION IS LINE SEQUENTIAL. 

        DATA DIVISION.
            FILE SECTION.
            FD cable1.
            01 cable1-file.
                05 cable1-direction PIC A(1).
                05 cable1-length PIC 9(10).
            FD cable2.
            01 cable2-file.
                05 cable2-direction PIC A(1).
                05 cable2-length PIC 9(10).

            WORKING-STORAGE SECTION.
            01 ws-cable-one.
                03 ws-cable-one-number PIC 9(4).
                03 ws-cable-one-segment OCCURS 400 TIMES
                                    INDEXED BY i.
                    05 ws-cable-one-start-x PIC S9(10).
                    05 ws-cable-one-start-y PIC S9(10).
                    05 ws-cable-one-end-x PIC S9(10).
                    05 ws-cable-one-end-y PIC S9(10).
            01 ws-current-x PIC S9(10) VALUE 0.
            01 ws-current-y PIC S9(10) VALUE 0.
            01 ws-new-x PIC S9(10) VALUE 0.
            01 ws-new-y PIC S9(10) VALUE 0.
            01 ws-min-x PIC S9(10) VALUE 0.
            01 ws-max-x PIC S9(10) VALUE 0.
            01 ws-min-y PIC S9(10) VALUE 0.
            01 ws-max-y PIC S9(10) VALUE 0.
            01 ws-found-intersection PIC A(1).
            01 ws-intersect-x PIC S9(10) VALUE 0.
            01 ws-intersect-y PIC S9(10) VALUE 0.
            01 ws-curr-manhattan PIC S9(10) VALUE 0.
            01 ws-min-manhattan PIC 9(10) VALUE 9999999999.
            01 ws-min-intersect-x PIC S9(10) VALUE 0.
            01 ws-min-intersect-y PIC S9(10) VALUE 0.
            01 WS-EOF PIC A(1). 
            01 ws-invalid-op PIC A(1). 

        PROCEDURE DIVISION.
            OPEN INPUT cable1.
                SET i TO 1.
                PERFORM UNTIL WS-EOF='Y'
                    MOVE 0 TO cable1-length
                    MOVE 'N' TO ws-invalid-op
                    READ cable1
                        AT END MOVE 'Y' TO WS-EOF
                        NOT AT END 
                            MOVE function numval (cable1-length)
                                TO cable1-length
                            EVALUATE TRUE
                                WHEN cable1-direction = "L"
                                    SUBTRACT cable1-length 
                                        FROM ws-current-x
                                        GIVING ws-new-x
                                WHEN cable1-direction = "R"
                                    ADD cable1-length 
                                        TO ws-current-x
                                        GIVING ws-new-x
                                WHEN cable1-direction = "U"
                                    SUBTRACT cable1-length 
                                        FROM ws-current-y
                                        GIVING ws-new-y
                                WHEN cable1-direction = "D"
                                 ADD cable1-length 
                                        TO ws-current-y
                                        GIVING ws-new-y
                                WHEN OTHER
                                    MOVE 'Y' TO ws-invalid-op
                            END-EVALUATE
                            IF ws-invalid-op NOT = 'Y'
                            MOVE function min(ws-current-x, ws-new-x)
                                TO ws-cable-one-start-x(i)
                            MOVE function min(ws-current-y, ws-new-y) 
                                TO ws-cable-one-start-y(i)
                            MOVE function max(ws-current-x, ws-new-x)
                                TO ws-cable-one-end-x(i)
                            MOVE function max(ws-current-y, ws-new-y)
                                TO ws-cable-one-end-y(i)
                            MOVE ws-new-x TO ws-current-x
                            MOVE ws-new-y TO ws-current-y
                            MOVE i TO ws-cable-one-number
                            SET i UP BY 1
                            END-IF
                    END-READ
                END-PERFORM.
            CLOSE cable1.
      
       SET i TO 1
      * PERFORM UNTIL i > ws-cable-one-number
      *     DISPLAY "start: x: " ws-cable-one-start-x(i) 
      *                 " y: " ws-cable-one-start-y(i) 
      *     DISPLAY "  end: x: " ws-cable-one-end-x(i) 
      *                 " y: " ws-cable-one-end-y(i) 
      *     SET i UP BY 1
      * END-PERFORM
         MOVE 'N' TO WS-EOF
         MOVE 0 TO ws-current-x
         MOVE 0 TO ws-current-y
         MOVE 0 TO ws-new-x
         MOVE 0 TO ws-new-y
      *   DISPLAY "----------"
         OPEN INPUT cable2.
             PERFORM UNTIL WS-EOF='Y'
                 MOVE 0 TO cable2-length
                 MOVE 'N' TO ws-invalid-op
                 READ cable2
                     AT END MOVE 'Y' TO WS-EOF
                     NOT AT END 
                         MOVE function numval (cable2-length)
                             TO cable2-length
                         EVALUATE TRUE
                             WHEN cable2-direction = "L"
                                 SUBTRACT cable2-length 
                                     FROM ws-current-x
                                     GIVING ws-new-x
                             WHEN cable2-direction = "R"
                                 ADD cable2-length 
                                     TO ws-current-x
                                     GIVING ws-new-x
                             WHEN cable2-direction = "U"
                                 SUBTRACT cable2-length 
                                     FROM ws-current-y
                                     GIVING ws-new-y
                             WHEN cable2-direction = "D"
                              ADD cable2-length 
                                     TO ws-current-y
                                     GIVING ws-new-y
                             WHEN OTHER
                                 MOVE 'Y' TO ws-invalid-op
                         END-EVALUATE
                 IF ws-invalid-op NOT = 'Y'
      *               DISPLAY "start: x: " ws-current-x
      *                          " y: " ws-current-y
      *               DISPLAY "  end: x: " ws-new-x
      *                          " y: " ws-new-y 
                    SET i TO 1
                    PERFORM UNTIL i > ws-cable-one-number
                        PERFORM INTERSECTS
                        IF ws-found-intersection = 'Y'
                        IF ws-intersect-x NOT = 0 
                        OR ws-intersect-y NOT = 0 THEN
                            COMPUTE ws-curr-manhattan = 
                                function abs(ws-intersect-x) +
                                function abs(ws-intersect-y)
                            IF ws-curr-manhattan < ws-min-manhattan
                                MOVE ws-curr-manhattan
                                    TO ws-min-manhattan 
                                MOVE ws-intersect-x
                                    TO ws-min-intersect-x
                                MOVE ws-intersect-y
                                    TO ws-min-intersect-y
                            END-IF
                        END-IF
                        END-IF
                        SET i UP BY 1
                    END-PERFORM

                    MOVE ws-new-x TO ws-current-x
                    MOVE ws-new-y TO ws-current-y
                 END-IF
                 END-READ
             END-PERFORM.
            CLOSE cable2.
      
            DISPLAY  "minX: " ws-min-intersect-x 
                    " minY: " ws-min-intersect-y
                    " distance: " ws-min-manhattan
      
        STOP RUN.
        
        INTERSECTS.
            MOVE 'N' TO ws-found-intersection.
            MOVE function min(ws-current-x, ws-new-x) TO ws-min-x.
            MOVE function min(ws-current-y, ws-new-y) TO ws-min-y.
            MOVE function max(ws-current-x, ws-new-x) TO ws-max-x.
            MOVE function max(ws-current-y, ws-new-y) TO ws-max-y.
            IF ws-min-x = ws-max-x THEN
                IF ws-cable-one-start-x(i) <= ws-min-x AND 
                    ws-cable-one-end-x(i) >= ws-max-x AND
                    ws-cable-one-start-y(i) >= ws-min-y AND 
                    ws-cable-one-end-y(i) <= ws-max-y THEN
                        MOVE 'Y' TO ws-found-intersection
                        MOVE ws-min-x TO ws-intersect-x
                        MOVE ws-cable-one-start-y(i) TO ws-intersect-y
                END-IF
            ELSE
                IF ws-cable-one-start-y(i) <= ws-min-y AND 
                    ws-cable-one-end-y(i) >= ws-max-y AND
                    ws-cable-one-start-x(i) >= ws-min-x AND 
                    ws-cable-one-end-x(i) <= ws-max-x THEN
                        MOVE 'Y' TO ws-found-intersection
                        MOVE ws-min-y TO ws-intersect-y
                        MOVE ws-cable-one-start-x(i) TO ws-intersect-x
                END-IF
            END-IF.
            
