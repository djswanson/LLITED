; Plot Figure 4
; NH and SH Neutral and plasma density, LLITED-B, TIE-GCM, IRI, MSIS
; use migsi files that have basic ephemeris but mission ephemeris files would work well
; D. Swanson 2025

datadir = 'C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\'
migsidatadir=datadir+'MIGSI\L2\'

pipdatadir=datadir+'PIP\L2\'

migsifile =['LLITEDB_MIGSI_20240507_033038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240508_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240510_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240511_050238_L2_v01.nc',$
  'LLITEDB_MIGSI_20240512_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240513_050138_L2_v01.nc']

pipfile=['LLITED_B_PIP_20240507_L2_v7.nc4',$
    'LLITED_B_PIP_20240508_L2_v7.nc4',$
    'LLITED_B_PIP_20240510_L2_v7.nc4',$
    'LLITED_B_PIP_20240511_L2_v7.nc4',$
    'LLITED_B_PIP_20240512_L2_v7.nc4',$
    'LLITED_B_PIP_20240513_L2_v7.nc4']

tiegcm_file='C:\Users\dswanson\Documents\Files\Satellites\LLITED\05 analysis\gannon day storm\TIE_GCM_LLITEDB_may5_may17_heelis_fanjiang_10s.txt'
tiegcm=read_tiegcmfile(tiegcm_file)

iri_file = 'C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\IRI\IRI2020_LLITEDB_202405.nc'
iri = read_iri(file=iri_file)

; order of files for subplot location
hem=[1,2,4,0,3,5]


for i=0,5 do begin $
  j = hem(i) &$

  sc='B' &$
  pip1=read_pip_l2file(file=pipdatadir+pipfile(j))&$

  migsi1=read_migsi_l2file(file=migsidatadir+migsifile(j)) &$
  w=where((migsi1.nden ne -1d0) ,nw2) &$

  plotstarts1970=floor(migsi1(0).s1970/300)*300   &$ ; start on 5-min boundary
  xras1970=plotstarts1970+[0,25*60]               &$ ; 25-minute plot
  ticks1970=plotstarts1970+400*dindgen(5)&$   ; 25*60/n_ticks
  tickalts=interpol(migsi1.alt,migsi1.s1970,ticks1970)&$
  ticklats=interpol(migsi1.lat,migsi1.s1970,ticks1970)&$
  ticklons=interpol(migsi1.lon,migsi1.s1970,ticks1970)&$
  ticklts=interpol(migsi1.ltime,migsi1.s1970,ticks1970)&$
  tickmlats=interpol(migsi1.mlat,migsi1.s1970,ticks1970)&$
  tickmlts=interpol(migsi1.mlt,migsi1.s1970,ticks1970)&$
  ticklabs=strcompress(fmttime(ticks1970,rep='s1970',form='%H%M')+'!C'+ $
  string(tickmlats,form='(f10.1)')+'!C'+ $
  string(tickmlts,form='(f10.1)'),/r)&$

  ; subplot layout for neutral and ion density plots
  neutral=[1,2,3,7,8,9]
  ion = [4,5,6,10,11,12]
  
  ; Plot MIGSI Neutral number density
  p0=plot(/current,dimensions=[1300,800],migsi1(w).s1970,migsi1(w).nden,thick=1,yra=[1e7,5e8], $
  tit=fmttime(xras1970(0),rep='s1970',form='%b %d %Y'), xshowtext=0,$
  ytit='Neutral Density $\n$($cm^{-3}$)','.k',xra=xras1970,xtickformat='(A1)',xtickvalues=ticks1970,xminor=4,$
  font_size=12,xtickfont_size=10.5,ytickfont_size=12,layout=[3,4,neutral(i)],margin=[0.25,0.05,0.1,0.15],name='MIGSI',xtickname=ticklabs)&$

  ; overplot MSIS model
  P2=PLOT(/overplot,/current,migsi1(w).s1970,migsi1(w).ndenmodel,layout=[3,2,neutral(i)],'b',name='MSIS',xshowtext=0)


  ; calculate number density from TIEGCM
  mm=1/((tiegcm.rhoo2/31.999)+(tiegcm.rhoo/15.999)+(tiegcm.n2/28.0134)+(tiegcm.rhoNO/30.01)+(tiegcm.rhon4s/88.0918)+(tiegcm.he/4.0026)) ; amu g/mol
  mm_kg = mm / (!const.na*1e3)
  tiegcm_n = tiegcm.den/mm_kg *1e-6 ; convert den to cm^-3 instead of m^-3

  ; truncate tiegcm and iri data to just when LLITED_B data exists
  ti = where((tiegcm.s1970 ge migsi1(w(0)).S1970) and (tiegcm.s1970 le migsi1(w(-1)).S1970))
  tiri = where((IRI.time ge migsi1(w(0)).S1970) and (IRI.time le migsi1(w(-1)).S1970))

  ; overplot TIEGCM neutral density
  p3=plot(/overplot,/current,tiegcm(ti).s1970,tiegcm_n(ti),layout=[3,4,neutral(i)],name='TIEGCM','lime green',thick=2) &$

  leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[p0,p2,p3],position = [ticks1970(-1), 4e8],font_size=12,transparency=100,linestyle=6,sample_width=0,vertical_spacing=0.01)&$

  ; Plot PIP data when MIGSI data exists. 
  ; PIP files are daily so include multiple passes while MIGSI files are only each pass providing an easy indicator when to cut the pip data
  wp= where(pip1.time ge migsi1(0).s1970 and pip1.time le migsi1(-1).s1970)

  tt = where((tiegcm.s1970 ge migsi1(0).s1970) and (tiegcm.s1970 le migsi1(-1).s1970))
  ; PLOT PIP ion density
  p1=plot(/current, pip1(wp).time,pip1(wp).ni/1e6,$
    xra=xras1970,xtickvalues=ticks1970,xminor=4,xtickname=ticklabs,$
    font_size=12,xtickfont_size=10.5,ytickfont_size=12,layout=[3,4,ion(i)],margin=[0.25,0.25,0.1,0],name='PIP','r',ytit='Ion Density $\n (cm^{-3})$',yra=[1e4,1.1e6])&$
  ; overplot tiegcm plasma density
  p5=plot(/current,/overplot,tiegcm(tt).s1970,$
    (tiegcm(tt).n_oplus+tiegcm(tt).n_o2plus),'cyan',layout=[3,4,ion(i)],margin=[0.25,0.25,0.1,0],thick=2,name='TIEGCM')
  
  ; overplot iri density
  p6=plot(/current,/overplot,iri(tiri).time,$
    iri(tiri)._NE/1e6,'dark violet',thick=2,layout=[3,4,ion(i)],margin=[0.25,0.3,0.1,0],name='IRI')


  phtextunits=text(target=p1,(p1.xrange)(0)-0.15*((p1.xrange)(1)-(p1.xrange)(0)),(p1.yrange)(0),/data,clip=0,al=0.5,vert=1.01, $
    '!C!C!Ahhmm!C!Adeg!C!Ahr',font_size=10.5)&$
    phtextqtys=text(target=p1,(p1.xrange)(0)-0.3*((p1.xrange)(1)-(p1.xrange)(0)),(p1.yrange)(0),/data,clip=0,al=0.5,vert=1.01, $
    '!C!C!AUT!C!AMLat!C!AMLT',font_size=10.5)&$

    leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[p1,p6,p5],position = [ticks1970(-1), 1e6],transparency=100,linestyle=6,sample_width=0,vertical_spacing=0.01,font_size=12)&$

endfor


;plot outlines
left=polyline([0,0],[405,800],/device,color='light salmon',thick=15)
bottom=polyline([0,1300],[402,402],/device,color='light salmon',thick=7)
top=polyline([0,1300],[800,800],/device,color='light salmon',thick=15)
right=polyline([1300,1300],[400,800],/device,color='light salmon',thick=15)

left=polyline([0,0],[0,395],/device,color='light sky blue',thick=15)
bottom=polyline([0,1300],[0,0],/device,color='light sky blue',thick=15)
top=polyline([0,1300],[397,397],/device,color='light sky blue',thick=7)
right=polyline([1300,1300],[0,395],/device,color='light sky blue',thick=15)


end
