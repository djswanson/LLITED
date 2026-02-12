; Plot Figure 3
; MIGSI (neutral density) and PIP (ion density) on May 11
; D. Swanson 2025
migsidatadir='C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\MIGSI\L2\'
pipdatadir='C:\Users\dswanson\Documents\Files\Satellites\LLITED\06 data\PIP\L2\'

migsifile = 'LLITEDB_MIGSI_20240511_050238_L2_v01.nc'
pipfile = 'LLITED_B_PIP_20240511_L2_v4.nc4'

migsi1=read_migsi_l2file(file=migsidatadir+migsifile) &$
pip1=read_pip_l2file(file=pipdatadir+pipfile) &$


w=where((migsi1.nden ne -1d0) ,nw2) &$

plotstarts1970=floor(migsi1(0).s1970/300)*300   &$ ; start on 5-min boundary
xras1970=plotstarts1970+[0,25*60]               &$ ; 25-minute plot
ticks1970=plotstarts1970+375*dindgen(6)&$
tickalts=interpol(migsi1.alt,migsi1.s1970,ticks1970)&$
ticklats=interpol(migsi1.lat,migsi1.s1970,ticks1970)&$
ticklons=interpol(migsi1.lon,migsi1.s1970,ticks1970)&$
ticklts=interpol(migsi1.ltime,migsi1.s1970,ticks1970)&$
tickmlats=interpol(migsi1.mlat,migsi1.s1970,ticks1970)&$
tickmlts=interpol(migsi1.mlt,migsi1.s1970,ticks1970)&$
ticklabs=strcompress(fmttime(ticks1970,rep='s1970',form='%H%M')+'!C'+ $
string(tickalts,form='(f10.1)')+'!C'+ $
string(ticklats,form='(f10.1)')+'!C'+ $
string(ticklons,form='(f10.1)')+'!C'+ $
string(ticklts,form='(f10.1)')+'!C'+ $
string(tickmlats,form='(f10.1)')+'!C'+ $
string(tickmlts,form='(f10.1)'),/r)&$


p1=plot(/current,dimensions=[600,400],migsi1(w).s1970,migsi1(w).nden,thick=1,yra=[1e7,5e8], $
tit='LLITED '+sc+' '+fmttime(xras1970(0),rep='s1970',form='%Y %b %d'),axis_style=1, $
ytit='Neutral Density $\n$($cm^{-3}$)','.k',xra=xras1970,xtickformat='(A1)',xtickvalues=ticks1970,xminor=4,$
font_size=14,xtickfont_size=12,ytickfont_size=12,layout=[1,1,i+1],margin=[0.22,0.3,0.165,0.1],name='MIGSI Neutral',xtickname=ticklabs)&$

; P2=PLOT(/overplot,/current,migsi1(w).s1970,migsi1(w).ndenmodel,layout=[3,1,i+1],'b',name='MSIS',xshowtext=0)

phtextunits=text(target=p1,(p1.xrange)(0)-0.15*((p1.xrange)(1)-(p1.xrange)(0)),(p1.yrange)(0)-.1,/data,clip=0,al=0.5,vert=1.01, $
'!C!C!Ahhmm!C!Akm!C!Adeg!C!Adeg!C!Ahr!C!Adeg!C!Ahr',font_size=12)&$
phtextqtys=text(target=p1,(p1.xrange)(0)-0.3*((p1.xrange)(1)-(p1.xrange)(0)),(p1.yrange)(0)-0.1,/data,clip=0,al=0.5,vert=1.01, $
'!C!C!AUT!C!AAlt!C!ALat!C!ALon!C!ALT!C!AMLat!C!AMLT',font_size=12)&$

date1=fmttime(xras1970(0),rep='s1970',form='%Y%m%d')&$

wp= where(pip1.time ge migsi1(0).s1970 and pip1.time le migsi1(-1).s1970)

xax=axis('X',location='top',target=p1,tickvalues=ticks1970,minor=4,showtext=0,tickfont_size=12)

p9=plot(/current,pip1(wp).time,pip1(wp).ni/1e6,layout=[1,1,i+1],xshowtext=0,axis_style=4, $
  xra=xras1970,xtickname=ticklabs,xtickvalues=ticks1970,xminor=4,$
  font_size=12,xtickfont_size=12,ytickfont_size=12,margin=[0.22,0.3,0.165,0.1],'r',yra=[0,1e6],name='PIP Ion')&$

yax=axis('Y',location='right',title='Ion Density $(cm^{-3})$',target=p9,color='r',textpos=1,tickdir=1,yra=[0,1e6],tickfont_size=12)
tt = where((tiegcm.s1970 ge migsi1(0).s1970) and (tiegcm.s1970 le migsi1(-1).s1970))

leg = LEGEND(/DATA, /AUTO_TEXT_COLOR,target=[p1,p9],position = [ticks1970(0)+700, 4.9e8],transparency=100,linestyle=6,sample_width=0,font_size=12)&$



end
