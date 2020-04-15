HAI 1.3
    CAN HAS STDIO?
    
    HOW IZ I execute YR input
        I HAS A index ITZ 0
        I HAS A exit ITZ FAIL
		IM IN YR executeLoop UPPIN YR t WILE DIFFRINT exit AN WIN
            BTW VISIBLE "execute index " index
            I HAS A op ITZ input'Z SRS index
            I HAS A arg1 ITZ input'Z SRS SUM OF index AN 1
            I HAS A arg2 ITZ input'Z SRS SUM OF index AN 2
            I HAS A dest ITZ input'Z SRS SUM OF index AN 3
            BTW VISIBLE "prog: " op " " arg1 " " arg2 " " dest
            arg1 R input'Z SRS arg1
            arg2 R input'Z SRS arg2

            op, WTF?
                OMG 1
                    BTW VISIBLE "adding " arg1 " and " arg2 " storing to " dest

                    input'Z SRS dest R SUM OF arg1 AN arg2
                    GTFO
                OMG 2                
                    BTW VISIBLE "multiplying " arg1 " " arg2

                    input'Z SRS dest R PRODUKT OF arg1 AN arg2
                    GTFO
                OMG 99
                    BTW VISIBLE "done"

                    exit R WIN
                    GTFO
            OIC
            index R SUM OF index AN 4

        IM OUTTA YR executeLoop
        
        FOUND YR input'Z SRS 0
	IF U SAY SO

    I HAS A input ITZ A BUKKIT
    input HAS A SRS "length" ITZ 0

    IM IN YR scan UPPIN YR count
        I HAS A scanner ITZ A YARN
        GIMMEH scanner
        DIFFRINT scanner AN "", O RLY?
            YA RLY
                scanner IS NOW A NUMBR
                input HAS A SRS count ITZ scanner
            NO WAI
                input'Z length R count
                GTFO
        OIC

    IM OUTTA YR scan

    I HAS A goal ITZ 19690720

    I HAS A result ITZ 0
    
    IM IN YR searchOne UPPIN YR x WILE BOTH OF DIFFRINT SMALLR OF x AN 100 AN 100 AN BOTH SAEM result AN 0
        IM IN YR searchTwo UPPIN YR y WILE BOTH OF DIFFRINT SMALLR OF y AN 100 AN 100  AN BOTH SAEM result AN 0 
            I HAS A inputCopy ITZ A BUKKIT

            IM IN YR copy UPPIN YR index TIL BOTH SAEM index AN input'Z length
                inputCopy HAS A SRS index ITZ input'Z SRS index
            IM OUTTA YR copy
            
            inputCopy'Z SRS 1 R x
            inputCopy'Z SRS 2 R y
            
            VISIBLE x " " y
            
            BOTH SAEM I IZ execute YR inputCopy MKAY AN goal, O RLY?
                YA RLY
                    result R SUM OF PRODUKT OF x AN 100 AN y
                    GTFO
                NO WAI
            OIC

    
        IM OUTTA YR searchTwo
    IM OUTTA YR searchOne
    VISIBLE "result: " result
  
KTHXBYE