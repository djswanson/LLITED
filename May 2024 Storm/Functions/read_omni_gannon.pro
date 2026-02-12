function read_omni_gannon,fname
  omni_dir='C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\OMNI\'


  ;fname='OMNI_indices_20240501.txt'
  file=omni_dir+fname



  nlines = FILE_LINES(file)
  content = STRARR(nlines)
  OPENR, unit, file,/GET_LUN
  READF, unit, content
  FREE_LUN, unit


; 1 YEAR                          I4
;  2 DOY                           I4
;  3 Hour                          I3
;  4 Scalar B, nT                  F6.1
;  5 BX, nT (GSE, GSM)             F6.1
;  6 BY, nT (GSE)                  F6.1
;  7 BZ, nT (GSE)                  F6.1
;  8 SW Plasma Temperature, K      F9.0
;  9 SW Proton Density, N/cm^3     F6.1
;  10 SW Plasma Speed, km/s         F6.0
;  11 Kp index                      I3
;  12 Dst-index, nT                 I6
;  13 f10.7_index                   F6.1
;  14 AE-index, nT                  I5
;  15 AL-index, nT                  I6
;  16 AU-index, nT                  I6
 
  data=content
  year=[]
  doy=[]
  hour=[]
  Bmag= []
  Bx=[]
  By=[]
  Bz=[]
  Tp=[]
  Np=[]
  Vp=[]
  Kp=[]
  Dst=[]
  f107=[]
  AE=[]
  AL=[]
  AU=[]
  
  OMNI_mag=replicate({s1970:-1d0,year:-1U,doy:-1U,hour:-1U,Bmag:-1d0,bx:-1d0,by:-1d0,bz:-1d0,$
    Tp:-1d0,Np:-1d0,Vp:1d0,Kp:-1d0,Dst:-1d0,f107:-1d0,AE:-1d0,AL:-1d0,AU:-1d0},n_elements(data))

  ;if (strsplit(data(0),' ',/extract))(0) eq 2024 then leap=1 else leap=0

  for i=0,n_elements(data)-1 do begin $
    dd=doy2md((strsplit(data(i),' ',/extract))(1),leap=leap,year=(strsplit(data(i),' ',/extract))(0)) &$
    ttime=((strsplit(data(i),' ',/extract))(0))+'-'+(strsplit(string(dd(0)),/extract))(0)+'-'+(strsplit(string(dd(1)),/extract))(0)+'T'+(strsplit(data(i),' ',/extract))(2)  &$
;    ttime=((strsplit(data(i),' ',/extract))(0))+'-'+(strsplit(string(dd(0)),/extract))(0)+'-'+(strsplit(string(dd(1)),/extract))(0)  &$

    T1=fmttime(ttime,rep='%Y-%m-%dT%H',/decode,format='s1970',/xml)&$

    OMNI_mag(i).S1970=cvtime(t1,from='tstruct',to='s1970')&$

    OMNI_mag(i).year=(strsplit(data(i),' ',/extract))(0) &$
    OMNI_mag(i).doy=(strsplit(data(i),' ',/extract))(1)  &$
    OMNI_mag(i).hour=(strsplit(data(i),' ',/extract))(2) &$
    OMNI_mag(i).Bmag=(strsplit(data(i),' ',/extract))(3) &$

    OMNI_mag(i).bx=((strsplit(data(i),' ',/extract))(4))   &$
    OMNI_mag(i).by=(strsplit(data(i),' ',/extract))(5) &$
    OMNI_mag(i).BZ=(strsplit(data(i),' ',/extract))(6) &$
    OMNI_mag(i).Tp=(strsplit(data(i),' ',/extract))(7)&$
    OMNI_mag(i).Np=(strsplit(data(i),' ',/extract))(8)&$
    OMNI_mag(i).Vp=(strsplit(data(i),' ',/extract))(9)&$
    OMNI_mag(i).Kp=(strsplit(data(i),' ',/extract))(10)&$
    OMNI_mag(i).Dst=(strsplit(data(i),' ',/extract))(11)&$
    OMNI_mag(i).f107=(strsplit(data(i),' ',/extract))(12)&$
    OMNI_mag(i).AE=(strsplit(data(i),' ',/extract))(13)&$
    OMNI_mag(i).AL=(strsplit(data(i),' ',/extract))(14)&$
    OMNI_mag(i).AU=(strsplit(data(i),' ',/extract))(15)&$

    
    
  endfor

;ttime=((strsplit(data(i),' ',/extract))(0))+'-'+(strsplit(string(dd(0)),/extract))(0)+'-'+(strsplit(string(dd(1)),/extract))(0)+'T'+(strsplit(data(i),' ',/extract))(2)

;ttime=((strsplit(data(i),' ',/extract))(0))+'-'+(strsplit(string(dd(0)),/extract))(0)+'-'+(strsplit(string(dd(1)),/extract))(0)+'T'+(strsplit(data(i),' ',/extract))(2)

return,OMNI_mag
end

