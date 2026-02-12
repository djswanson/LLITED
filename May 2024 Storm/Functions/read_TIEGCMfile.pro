function read_TIEGCMfile,file
;file='C:\Users\dswanson\Documents\Files\Satellites\LLITED\05 analysis\gannon day storm\May_TIEGCM_LLITEDB.txt'

TIEGCM_struct={s1970:-1d0,Year:1U,Month:1U,Day:1U ,Hour:1U ,Min:1U ,Sec:1U,Lon:-1d0 ,Lat:-1d0,H:-1d0,T_n:-1d0,$
  Vn_Lon:-1d0,Vn_Lat:-1d0 ,WN:-1d0,rhoO2:-1d0 ,rhoO:-1d0,N2:-1d0,rhoNO:-1d0,rhoN4S:-1d0,HE:-1d0,N_e:-1d0,$
  T_e:-1d0,T_i:-1d0 ,TEC:-1d0,N_O2plus:-1d0,N_Oplus:-1d0,PHI:-1d0,Vi_Lon:-1d0,Vi_Lat:-1d0,Vi_IP:-1d0 ,DEN:-1d0,$
  QJOULE:-1d0,HMF2:-1d0,NMF2:-1d0,Z:-1d0,ZG:-1d0,SIGMA_PED:-1d0,SIGMA_HAL:-1d0,NO_COOL:-1d0,T_lbc:-1d0,Vlbc_Lon:-1d0,$
  Vlbc_Lat:-1d0,TN_lbc:-1d0,VN_lbc_Lon:-1d0,VN_lbc_Lat:-1d0}

TIEGCM=replicate(TIEGCM_struct,file_lines(file)-9)
;head=['Year','Month' ,'Day' ,'Hour' ,'Min' ,'Sec','Lon' ,'Lat','H','T_n','Vn_Lon','Vn_Lat' ,'WN','rho(O2)' ,'rho(O)',\
;'N2','rho(NO)','rho(N4S)','HE','N_e','T_e','T_i' ,'TEC','N(O2+)','N(O+)','PHI','Vi_Lon','Vi_Lat ','Vi_IP' ,'DEN', \
;'QJOULE','HMF2','NMF2','Z','ZG','SIGMA_PED','SIGMA_HAL','NO_COOL','T_lbc','Vlbc_Lon','Vlbc_Lat','TN_lbc','VN,lbc_Lon'\
;,'VN,lbc_Lat']

data=read_ascii(file,deliminator=' ',data_start=9,header=head)



TIEGCM.year = reform(data.field01(0,*))

TIEGCM.month = reform(data.field01(1,*))
TIEGCM.day= reform(data.field01(2,*))
TIEGCM.Hour = reform(data.field01(3,*))
TIEGCM.Min = reform(data.field01(4,*))
TIEGCM.sec = reform(data.field01(5,*))

t=strarr(n_elements(tiegcm.year))
for i=0,n_elements(TIEGCM.year)-1 do begin $
t(i)=string(TIEGCM[i].year)+string(TIEGCM[i].month)+string(TIEGCM[i].day)+' '+string(TIEGCM[i].hour)+string(TIEGCM[i].min)+string(TIEGCM[i].sec)&$
endfor
  
TIEGCM.s1970=fmttime(t,form='%Y%m%d %H%M%S',/dec,rep='s1970')

TIEGCM.lon = reform(data.field01(6,*))
TIEGCM.lat= reform(data.field01(7,*))
TIEGCM.H= reform(data.field01(8,*))
TIEGCM.T_n = reform(data.field01(9,*))
TIEGCM.Vn_lon= reform(data.field01(10,*))
TIEGCM.Vn_lat = reform(data.field01(11,*))
TIEGCM.WN= reform(data.field01(12,*))
TIEGCM.rhoO2= reform(data.field01(13,*))
TIEGCM.rhoO= reform(data.field01(14,*))
TIEGCM.N2= reform(data.field01(15,*))
TIEGCM.rhoNO= reform(data.field01(16,*))
TIEGCM.rhoN4S= reform(data.field01(17,*))
TIEGCM.HE= reform(data.field01(18,*))
TIEGCM.N_e= reform(data.field01(19,*))
TIEGCM.T_e= reform(data.field01(20,*))
TIEGCM.T_i = reform(data.field01(21,*))
TIEGCM.TEC = reform(data.field01(22,*))
TIEGCM.N_O2plus= reform(data.field01(23,*))
TIEGCM.N_Oplus= reform(data.field01(24,*))
TIEGCM.PHI= reform(data.field01(25,*))
TIEGCM.Vi_Lon= reform(data.field01(26,*))
TIEGCM.Vi_Lat= reform(data.field01(27,*))
TIEGCM.Vi_IP= reform(data.field01(28,*))
TIEGCM.DEN= reform(data.field01(29,*))
TIEGCM.QJOULE= reform(data.field01(30,*))
TIEGCM.HMF2= reform(data.field01(31,*))
TIEGCM.NMF2= reform(data.field01(32,*))
TIEGCM.Z= reform(data.field01(33,*))
TIEGCM.ZG= reform(data.field01(34,*))
TIEGCM.SIGMA_PED= reform(data.field01(35,*))
TIEGCM.SIGMA_HAL= reform(data.field01(36,*))
TIEGCM.NO_COOL= reform(data.field01(37,*))
TIEGCM.T_lbc= reform(data.field01(38,*))
TIEGCM.Vlbc_Lon= reform(data.field01(39,*))
TIEGCM.VLBC_Lat= reform(data.field01(40,*))
TIEGCM.TN_lbc= reform(data.field01(41,*))
TIEGCM.VN_lbc_Lon= reform(data.field01(42,*))
TIEGCM.VN_lbc_Lat= reform(data.field01(43,*))




return, TIEGCM
end
