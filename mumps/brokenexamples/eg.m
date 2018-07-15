 zsample ;dpb;09:18 PM  6 Aug 1994
 
         ;Test the Stats routine:        
         ;Calculate 1000 points w. approx. Gaussian distribution,
         ;then call Stats on the result
         ;Execution time: 5 seconds with DTM on a 33 MHz 386DX
 
          New Data,i,j,output
          For i=1:1:1000 Set Data(i)=$$Normal
         Do Stats("Data",.output)
         Write !,output
         Quit
      
         ;------------------------------------------------------------
         ;Based on Lewkowicz, "The Complete MUMPS," examples 9.15-9.17
         ;Modified slightly:
         ;Used argumentless Do instead of two If's for Num>1 block
         ;Corrected calculation of the standard error
         ;------------------------------------------------------------
      
 Stats(Ref,Results) ; Calculate simple Statistics on Array nodes
         New High,i,Low,Mean,Num,StdDev,StdErr,s,Sum,SumSQ,Var
         Set High=-1E25,Low=1E25,(Sum,SumSQ,Num)=0,s=""
         For  Set s=$O(@Ref@(s)) Q:s=""  Do StatsV(@Ref@(s))
         If 'Num Set Results="" Goto StatsX
         Set Mean=Sum/Num
         Set (StdDev,StdErr,Var)=""
         If Num>1 Do
         . Set Var=-Num*Mean*Mean+SumSQ/(Num-1)
         . Set StdDev=$$SQroot(Var)
         . Set StdErr=StdDev/$$SQroot(Num)
         Set Results=Num_";"_Low_";"_High_";"_Mean
         Set Results=Results_";"_Var_";"_StdDev_";"_StdErr
         Goto StatsX
 StatsV(Val) ;Process an individual value
           Set Val=$$NumChk(Val) Quit:Val=""
          Set Num=Num+1,Sum=Sum+Val,SumSQ=Val*Val+SumSQ
          Set:Val<Low Low=Val Set:Val>High High=Val
          Quit
 StatsX   Quit
 
 SQroot(Num) ;Return the SQUARE ROOT of abs(Num)
         New prec,Root Set Root=0 Goto SQrootX:Num=0
         Set:Num<0 Num=-Num Set Root=$S(Num>1:Num\1,1:1/Num)
         Set Root=$E(Root,1,$L(Root)+1\2) Set:Num'>1 Root=1/Root
         For prec=1:1:6 Set Root=Num/Root+Root*.5
 SQrootX      Quit Root
 
 NumChk(Data,Range,Dec) ;Check for valid NUMBER
         Set Data=$TR(Data,"+ $,")
         Goto NumChkE:Data'?.E1N.E,NumChkE:Data'?."-".N.".".N
         If $D(Dec),Dec?1N.N g NumChkE:$L($P(Data,".",2))>Dec
         Set:'$D(Range) Range="" Set:Range="" Range="-1E25:1E25"
         If $P(Range,":")'="" Goto NumChkE:Data<$P(Range,":")
         If $P(Range,":",2)'="" Goto NumChkE:Data>$P(Range,":",2)
         Set Data=+Data Goto NumChkX
 NumChkE      Set Data=""
 NumChkX Quit Data
      ;
      ;------------------------------------------------------------------
      ;
      ;Part of demo/test code, Dan Smith, 8/26/94
 Normal() ;Return random # with approximately Gaussian distribution
         New i,x,n ;n=# iterations
         Set x=0,n=3 ;Higher n = slower, better Gaussian approximation
         ;$random(1201) has approx. mean=600, variance=120000
         For i=1:1:n*n Set x=x+$random(1201)-600
         Set x=x/(346.4101615*n) ;variance now 1
         Quit 
