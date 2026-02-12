; Plot Figure 2
; NH and SH LLITED-B trajectories
; use migsi files that have basic ephemeris but mission ephemeris files would work well
; D. Swanson 2025

migsidatadir='C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\MIGSI\L2\'

file =['LLITEDB_MIGSI_20240507_033038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240508_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240510_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240511_050238_L2_v01.nc',$
  'LLITEDB_MIGSI_20240512_094038_L2_v01.nc',$
  'LLITEDB_MIGSI_20240513_050138_L2_v01.nc']

files = migsidatadir+file

SH=[0,3,5]
NH=[1,2,4]

sc='B' &$
;SH
  migsi1=read_migsi_l2file(file=files(SH(0))) &$
  migsi2=read_migsi_l2file(file=files(SH(1))) &$
  migsi3=read_migsi_l2file(file=files(SH(2))) &$
;NH  
  migsi4=read_migsi_l2file(file=files(NH(0))) &$
  migsi5=read_migsi_l2file(file=files(NH(1))) &$
  migsi6=read_migsi_l2file(file=files(NH(2))) &$

; PLOT NORTHERN HEMISPHERE
p1=plot(/current,/pol,aspect_r=1,[0],[0],axis_style=4,symbol=1,xra=[-.5,.5],yra=[-.5,.5], $
tit='Northern Hemisphere!C',font_size=12,layout=[2,1,1],dim=[600,310]) &$ 
for i=15,45,15 do dum=plot(/over,i/90.0*cos(findgen(361)*!dtor),i/90.0*sin(findgen(361)*!dtor),thick=0) &$

for i=0,24,6 do dum=plot(/over,/pol,[40,50]/90.0,replicate(i*15*!dtor,2),thick=1) &$
for i=0,24 do dum=plot(/over,/pol,[42.5,47.5]/90.0,replicate(i*15*!dtor,2),thick=0) &$
dum=text(target=p1,.37,.37,/data,clip=0,'45$\deg$',al=0.0,vert=0.5,font_size=11) &$


dum=text(target=p1,.55,0,/data,clip=0,'06',al=0.0,vert=0.5,font_size=12) &$
dum=text(target=p1,0,.5,/data,clip=0,'12',al=0.5,vert=-0.3,font_size=12) &$
dum=text(target=p1,-0.55,0,/data,clip=0,'18',al=1,vert=0.5,font_size=12) &$
dum=text(target=p1,0,-0.5,/data,clip=0,'00',al=0.5,vert=1.2,font_size=12) &$
dum=text(target=p1,0,-0.55,/data,clip=0,'Geomagnetic Coordinates',al=0.5,vert=2.2,font_size=12) &$

cart=cv_coord(/deg,/double,from_polar=transpose([[(migsi4.mlt-6)*15],[1-migsi4.mlat/90]]),/to_rect) &$
dum4=plot(/over,cart(0,*),cart(1,*),thick=1,'k',name='May 8') &$
cart=cv_coord(/deg,/double,from_polar=transpose([[(migsi5.mlt-6)*15],[1-migsi5.mlat/90]]),/to_rect) &$
dum5=plot(/over,cart(0,*),cart(1,*),thick=1,'purple',name='May 10') &$
cart=cv_coord(/deg,/double,from_polar=transpose([[(migsi6.mlt-6)*15],[1-migsi6.mlat/90]]),/to_rect) &$
dum6=plot(/over,cart(0,*),cart(1,*),thick=1,'b',name='May 12') &$
leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[dum4,dum5,dum6],position = [-0.40,-0.2],transparency=100,linestyle=6,sample_width=0,font_size=11)

; PLOT SOUTHERN HEMISPHERE

p1=plot(/current,/pol,aspect_r=1,[0],[0],axis_style=4,symbol=1,xra=[-0.5,0.5],yra=[-0.5,0.5], $
tit='Southern Hemisphere!C',font_size=12,layout=[2,1,2]) &$; layout=[3,4,12],margin=[0.16,0.25,0.2,0.25]) &$
for i=15,45,15 do dum=plot(/over,i/90.0*cos(findgen(361)*!dtor),i/90.0*sin(findgen(361)*!dtor),thick=0) &$
for i=0,24,6 do dum=plot(/over,/pol,[40,50]/90.0,replicate(i*15*!dtor,2),thick=1) &$
for i=0,24 do dum=plot(/over,/pol,[42.5,47.5]/90.0,replicate(i*15*!dtor,2),thick=0) &$
dum=text(target=p1,.37,.37,/data,clip=0,'-45$\deg$',al=0.0,vert=0.5,font_size=11) &$

dum=text(target=p1,.55,0,/data,clip=0,'18',al=0.0,vert=0.5,font_size=12) &$
dum=text(target=p1,0,0.5,/data,clip=0,'12',al=0.5,vert=-0.3,font_size=12) &$
dum=text(target=p1,-.55,0,/data,clip=0,'06',al=1,vert=0.5,font_size=12) &$
dum=text(target=p1,0,-0.5,/data,clip=0,'00',al=0.5,vert=1.2,font_size=12) &$
dum=text(target=p1,0,-0.55,/data,clip=0,'Geomagnetic Coordinates',al=0.5,vert=2.2,font_size=12) &$

cart=cv_coord(/deg,/double,from_polar=transpose([[(18-migsi1.mlt)*15],[1+migsi1.mlat/90]]),/to_rect) &$
dum1=plot(/over,cart(0,*),cart(1,*),thick=1,'g',name='May 7') &$
cart=cv_coord(/deg,/double,from_polar=transpose([[(18-migsi2.mlt)*15],[1+migsi2.mlat/90]]),/to_rect) &$
dum2=plot(/over,cart(0,*),cart(1,*),thick=1,'dark orange',name='May 11') &$
cart=cv_coord(/deg,/double,from_polar=transpose([[(18-migsi3.mlt)*15],[1+migsi3.mlat/90]]),/to_rect) &$
dum3=plot(/over,cart(0,*),cart(1,*),thick=1,'r',name='May 13') &$

leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[dum1,dum2,dum3],position = [-0.40,-0.2],transparency=100,linestyle=6,sample_width=0,font_size=11)

; Outlines
left=polyline([0,0],[0,310],/device,color='light salmon',thick=15)
bottom=polyline([0,295],[0,0],/device,color='light salmon',thick=15)
top=polyline([0,295],[310,310],/device,color='light salmon',thick=15)
right=polyline([297.5,297.5],[0,310],/device,color='light salmon',thick=6)

left=polyline([302.5,302.5],[0,310],/device,color='light sky blue',thick=6)
bottom=polyline([310,600],[0,0],/device,color='light sky blue',thick=15)
top=polyline([310,600],[310,310],/device,color='light sky blue',thick=15)
right=polyline([600,600],[0,310],/device,color='light sky blue',thick=15)



end
