; Plot omni data for May 2024 Geomagnetic Storm
; Figure 1 
; D. Swanson 2025

omni=read_omni_gannon('may2024.txt')
migsidatadir='C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\MIGSI\L2\'


; Read in MIGSI data to find times for vertical lines on plot of when LLITED_B was operating
migsifile=[ 'LLITEDB_MIGSI_20240507_033038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240508_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240510_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240511_050238_L2_v01.nc',$
  'LLITEDB_MIGSI_20240512_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240513_050138_L2_v01.nc']
  
dtime0NH=[]
dtime0SH=[]

for i=0,n_elements(may_data)-1 do begin &$

  migsi=read_migsi_l2file(file=migsidatadir+migsifile(i)) &$

  if (mean(migsi.lat) ge 0) then begin &$
  dtime0NH=[dtime0NH,migsi(0).s1970,migsi(-1).s1970] &$
  endif else begin &$
  dtime0SH = [dtime0SH,migsi(0).s1970,migsi(-1).s1970] &$
  endelse &$

endfor

omniplotstarts1970=1715040000; start of May 7 
omniplotends1970=1715644799; end of May 13 

omniticks1970=[omniplotstarts1970:omniplotends1970:86400]&$

omniticklabs=strcompress(fmttime(omniticks1970,rep='s1970',form='%d'),/r) &$


p1=plot(omni.s1970,omni.bmag,color='k',layout=[1,5,1],xshowtext=0,name='$|B|$',$
  dimensions=[500,650],xtickname=omniticklabs,xtickvalues=omniticks1970,ytit='B (nT)',$
    tit='OMNI2 Geomagnetic Conditions$\n$',xrange=[omniplotstarts1970,omniplotends1970],font_size=12,margin=[0.16,0.1,0.15,0.25],yra=[-80,80])
p2=plot(omni.s1970,omni.bx,color='b',layout=[1,5,1],/current,/overplot,name='$B_x$')
p3=plot(omni.s1970,omni.by,color='g',layout=[1,5,1],/current,/overplot,name='$B_y$')
p4=plot(omni.s1970,omni.bz,color='r',layout=[1,5,1],/current,/overplot,name='$B_z$')
leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,position = [omniplotends1970+90000, 80],transparency=100,font_size=12,vertical_spacing=0.001,linestyle=6,sample_width=0)&$

for j=0,n_elements(dtime0NH)-1 do begin &$
  st=make_array(11,value=dtime0NH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot,  thick=2,'light salmon') &$
endfor

for j=0,n_elements(dtime0SH)-1 do begin &$
  st=make_array(11,value=dtime0SH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot,  thick=2,'light sky blue') &$
endfor

t1=text([.165,.291,.486,.565,.685,.77],[0.955,0.955,0.955,0.955,0.955,0.955],['A','B','C','D','E','F'],$
  color=['light sky blue','light salmon','light salmon','light sky blue','light salmon','light sky blue'],FONT_STYLE='bold',font_size=12)
t1=text(0.85,0.96,'NH',color='light salmon',font_size=16,font_style='bold')
t1=text(0.93,0.96,'SH',color='light sky blue',font_size=16,font_style='bold')


w2=where(omni.Np le 100)
p9=plot(omni(w2).s1970,omni(w2).Np,color='.k',layout=[1,5,2],/current,yra=[0,50],ytit='$N_p (cm^{-3})$',xshowtext=0,$
xtickname=omniticklabs,xtickvalues=omniticks1970,xrange=[omniplotstarts1970,omniplotends1970],margin=[0.16,0.1,0.15,0.1],font_size=12)

xax=axis('X',location='top',target=p9,tickvalues=omniticks1970,minor=4,showtext=0)
w1=where(omni.Vp le 1200)
p12=plot(omni(w1).s1970,omni(w1).Vp,layout=[1,5,2],color='.r',/current,axis_style=4,font_size=12,margin=[0.16,0.1,0.15,0.1],$
  xrange=[omniplotstarts1970,omniplotends1970],xtickname=omniticklabs,xtickvalues=omniticks1970,yra=[300,1100],xshowtext=0)


yax=axis('Y',location='right',title='$V_p (km/s)$',target=p12,color='r',textpos=1,tickdir=1,axis_range=[200,1200],tickfont_size=12)


for j=0,n_elements(dtime0NH)-1 do begin &$
  st=make_array(11,value=dtime0NH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot, thick=2, 'light salmon') &$
endfor

for j=0,n_elements(dtime0SH)-1 do begin &$
  st=make_array(11,value=dtime0SH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot,thick=2,  'light sky blue') &$
  endfor


p911=plot(omni.s1970,omni.f107,'k',layout=[1,5,5],ytit='F 10.7 (sfu)',xtit='UT May 2024',yra=[200,240],/current,xtickname=omniticklabs,$
  xtickvalues=omniticks1970,xrange=[omniplotstarts1970,omniplotends1970],margin=[0.16,0.4,0.15,0.02],font_size=12);,margin=[0.16,0.1,0.15,0.1])


for j=0,n_elements(dtime0NH)-1 do begin &$
  st=make_array(11,value=dtime0NH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p11=plot(st,vert,/current,/overplot, thick=2, 'light salmon',name='NH') &$
endfor

for j=0,n_elements(dtime0SH)-1 do begin &$
  st=make_array(11,value=dtime0SH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p13=plot(st,vert,/current,/overplot, thick=2, 'light sky blue',name='SH') &$
endfor


w3=where(omni.AE le 4000)
 p5=plot(omni(w3).s1970,omni(w3).AE,'-b',layout=[1,5,4],ytit='AE (nT)',/current,font_size=12,yra=[-2000,2000],xtickname=omniticklabs,xtickvalues=omniticks1970,xrange=[omniplotstarts1970,omniplotends1970],xshowtext=0,margin=[0.16,0.1,0.15,0.1],name='AE')
 p6=plot(omni(w3).s1970,omni(w3).AU,'-r',layout=[1,5,4],/current,/overplot,name='AU')
 p7=plot(omni(w3).s1970,omni(w3).AL,'-g',layout=[1,5,4],/current,/overplot,name='AL')
 leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[p5,p6,p7],position = [omniplotends1970+90000, 2000],transparency=100,font_size=12,linestyle=6,sample_width=0)&$


for j=0,n_elements(dtime0NH)-1 do begin &$
  st=make_array(11,value=dtime0NH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot,thick=2,  'light salmon') &$
endfor

for j=0,n_elements(dtime0SH)-1 do begin &$
  st=make_array(11,value=dtime0SH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot, thick=2, 'light sky blue') &$
endfor


p9=plot(omni.s1970,omni.Dst,axis_style=1,color='k',layout=[1,5,3],/current,font_size=12,xtickname=omniticklabs,xtickvalues=omniticks1970,ytit='Dst (nT)'$
  ,xrange=[omniplotstarts1970,omniplotends1970],margin=[0.16,0.1,0.15,0.1],xshowtext=0,yra=[-450,100])

xax=axis('X',location='top',target=p9,tickvalues=omniticks1970,minor=4,showtext=0,tickfont_size=12);,tickdir=1)

p12=plot(omni.s1970,omni.kp/10,layout=[1,5,3],color='b',font_size=12,/current,axis_style=4,margin=[0.16,0.1,0.15,0.1]$
  ,xrange=[omniplotstarts1970,omniplotends1970],xtickname=omniticklabs,xshowtext=0,xtickvalues=omniticks1970,yra=[0,9]);[min(omni_indx.dst),max(omni_indx.dst)])
yax=axis('Y',location='right',title='kp',target=p12,color='b',textpos=1,tickdir=1,axis_range=[0,9],tickfont_size=12)



for j=0,n_elements(dtime0NH)-1 do begin &$
  st=make_array(11,value=dtime0NH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot, thick=2, 'light salmon') &$
endfor

for j=0,n_elements(dtime0SH)-1 do begin &$
  st=make_array(11,value=dtime0SH(j),/double) &$
  vert=indgen(11,start=-6000,increment=2000) &$
  p7=plot(st,vert,/current,/overplot, thick=2, 'light sky blue') &$
endfor



end
