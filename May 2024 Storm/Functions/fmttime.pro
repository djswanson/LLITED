; IDL function returns formatted time string or the time represented
; by a formatted time string.  Format is as in the standard C routine
; strftime (3C) for encoding and strptime (3C) for decoding.  The codes
; are indicated here after  the program body.  A non-standard extension
; allows printing fractional seconds using the specification %[0-9]f.
; Here the optional number specifies the number of digits after decimal
; point.
; The keyword "representation" indicates which time representation 
; is being passed to the routine, with valid values given in routine
; cvtime.
; The keyword "round" controls rounding.  It is especially important
; when using floating point time representations.  See cvtime.
; When the keyword "decode" is set, decoding occurs.  The default is
; to encode.
; The keyword "parsepos" can be used to indicate at which character
; to begin parsing when decoding.  On exit it will be set to the
; next character to be parsed.
; jhc,1/97
;
; XML-style "datetime" formatting added, jhc, 2/08.  Uses keyword XML

function fmttime,intime,format=format,representation=rep,round=rnd, $
                 decode=decode,parsepos=parsepos,xml=xml

; Some statics
common fmttime,wkdays,weekdays,mons,months,equivalents
if(n_elements(wkdays) le 0) then begin
  wkdays=['Sun','Mon','Tue','Wed','Thu','Fri','Sat','Sun']
  weekdays=['Sunday','Monday','Tuesday','Wednesday','Thursday', $
           'Friday','Saturday','Sunday']
  mons=['Jan','Feb','Mar','Apr','May','Jun', $
        'Jul','Aug','Sep','Oct','Nov','Dec']
  months=['January','February','March','April','May','June', $
          'July','August','September','October','November','December']
  equivalents=[['%A','%a'],['%B','%b'],['%c','%a %b %d %T %Y'], $
               ['%D','%m/%d/%y'],['%e','%d'],['%E',''],['%h','%b'], $
               ['%k','%H'],['%l','%I'],['%n',''],['%O',''], $
               ['%r','%I:%M:%S %p'],['%R','%H:%M'],['%t',''], $
               ['%T','%H:%M:%S'],['%x','%m/%d/%y'],['%X','%H:%M:%S']]
endif

if(keyword_set(XML)) then begin
  if (xml eq 1) then return,fmttime(intime,format='%Y-%m-%dT%H:%M:%S', $
                                  representation=rep,round=rnd,decode=decode,parsepos=parsepos) $
  else return,fmttime(intime,format='%Y-%m-%dT%H:%M:%S%'+string((round(xml*10)>0)<9,form='(i1)')+'f', $
                                  representation=rep,round=rnd,decode=decode,parsepos=parsepos)
endif

if(keyword_set(decode)) then goto,decode

tstruct=cvtime(intime,from=rep,to='tstruct',round=rnd)
weekday1=(julday(1,1,tstruct.year)+1) mod 7         ; day of week on 1 Jan
week1=(tstruct.dayofyear+(weekday1+5) mod 7)/7
;-------------------------------------------------------
; vectorize next lines
;  if(((weekday1+5) mod 7) le 2) then week2=week1+1 $
;  else if(week1 eq 0) then week2=53 else week2=week1
week2=week1
w=where(((weekday1+5) mod 7) le 2,nw)
if(nw gt 0) then week2(w)=week1(w)+1
w=where(((weekday1+5) mod 7) gt 2,nw)
if(nw gt 0) then begin
  w1=where(week1(w) eq 0,nw1)
  if(nw1 gt 0) then week2(w(w1))=53
  w1=where(week1(w) ne 0,nw1)
  if(nw1 gt 0) then week2(w(w1))=week1(w(w1))
endif
;-------------------------------------------------------

if(not keyword_set(format)) then format='%c'

fmt=format
str=''
num=''
escape=0
i=0l
while(i lt strlen(fmt)) do begin
  char=strmid(fmt,i,1)
  if(escape eq 0) then if(char eq '%') then escape=1 else str=str+char $
  else begin
    if(isdigit(char)) then num=num+char else begin
      escape=0
      case char of
        '%': str=str+char
        'a': str=str+wkdays(tstruct.weekday)
        'A': str=str+weekdays(tstruct.weekday)
;        'A': fmt=strmid(fmt,0,i+1)+'%a'+strmid(fmt,i+1,1000)
        'b': str=str+mons(tstruct.month-1)
        'B': str=str+months(tstruct.month-1)
;        'B': fmt=strmid(fmt,0,i+1)+'%b'+strmid(fmt,i+1,1000)
;        'c': str=str+fmttime(intime,form='%a %b %d %T %Y',rep=rep,round=rnd)
        'c': fmt=strmid(fmt,0,i+1)+'%a %b %d %T %Y'+strmid(fmt,i+1,1000)
;        'C': str=str+fmttime(intime,form='%a %b %e %T %Z %Y',rep=rep,round=rnd)
        'C': fmt=strmid(fmt,0,i+1)+'%a %b %e %T %Z %Y'+strmid(fmt,i+1,1000)
        'd': str=str+string(tstruct.day,form='(i2.2)') &$
;        'D': str=str+fmttime(intime,form='%m/%d/%y',rep=rep,round=rnd)
        'D': fmt=strmid(fmt,0,i+1)+'%m/%d/%y'+strmid(fmt,i+1,1000)
;        'e': str=str+string(tstruct.day,form='(i2)')
        'e': fmt=strmid(fmt,0,i+1)+'%d'+strmid(fmt,i+1,1000)
        'E': escape=1
        'f': begin                ; fractions of seconds (non-standard)
          field=3l                ; default field size
          if(strlen(num) gt 0) then reads,num,field
          str=str+strmid(string((tstruct.millisecond+tstruct.remain)*1d-3, $
                  form='(f'+strtrim(string(field+2),2)+'.'+ $
                            strtrim(string(field),2)+')'),1,100)
          num=''
        end
;        'h': str=str+mons(tstruct.month-1)
        'h': fmt=strmid(fmt,0,i+1)+'%b'+strmid(fmt,i+1,1000)
        'H': str=str+string(tstruct.hour,form='(i2.2)')
        'I': str=str+string((tstruct.hour+11) mod 12+1,form='(i2.2)')
        'j': str=str+string(tstruct.dayofyear,form='(i3.3)')
;        'k': str=str+string(tstruct.hour,form='(i2)')
        'k': fmt=strmid(fmt,0,i+1)+'%H'+strmid(fmt,i+1,1000)
;        'l': str=str+string((tstruct.hour+11) mod 12+1,form='(i2)')
        'l': fmt=strmid(fmt,0,i+1)+'%I'+strmid(fmt,i+1,1000)
        'm': str=str+string(tstruct.month,form='(i2.2)')
        'M': str=str+string(tstruct.minute,form='(i2.2)')
        'n': str=str+'!C'                               ; newline
        'O': escape=1
        'p': str=str+(['AM','PM'])(tstruct.hour ge 12)
;        'r': str=str+fmttime(intime,form='%I:%M:%S %p',rep=rep,round=rnd)
        'r': fmt=strmid(fmt,0,i+1)+'%H:%M:%S%I:%M:%S %p'+strmid(fmt,i+1,1000)
;        'R': str=str+string(tstruct.hour,tstruct.minute,form='(i2.2,":",i2.2)')
        'R': fmt=strmid(fmt,0,i+1)+'%H:%M'+strmid(fmt,i+1,1000)
        'S': str=str+string(tstruct.second,form='(i2.2)')
        't': str=str+string(9b)
;        'T': str=str+string(tstruct.hour,tstruct.minute,tstruct.second,form='(i2.2,2(":",i2.2))')
        'T': fmt=strmid(fmt,0,i+1)+'%H:%M:%S'+strmid(fmt,i+1,1000)
        'u': str=str+string(tstruct.weekday+1,form='(i1)')
        'U': str=str+string(tstruct.weekofyear,form='(i2.2)')
        'V': str=str+string(week2,form='(i2.2)')
        'w': str=str+string(tstruct.weekday,form='(i1)')
        'W': str=str+string(week1,form='(i2.2)')
;        'x': str=str+string(tstruct.month,tstruct.day,tstruct.year mod 100,form='(i2.2,2("/",i2.2))')
        'x': fmt=strmid(fmt,0,i+1)+'%m/%d/%y'+strmid(fmt,i+1,1000)
;        'X': str=str+fmttime(intime,form='%T',rep=rep,round=rnd)
        'X': fmt=strmid(fmt,0,i+1)+'%T'+strmid(fmt,i+1,1000)
        'y': str=str+string(tstruct.year mod 100,form='(i2.2)')
        'Y': str=str+string(tstruct.year,form='(i4.4)')
        'Z': str=str+'GMT'   ; not sure what to do
        else:
      endcase
    endelse
  endelse
  i=i+1
endwhile

return,str

decode:   ; decode the string instead of encoding it

;year=2l^31 & month=year & day=year & hour=0l & minute=0l & second=0l
;year=long('0'+intime)+2l^31 & month=year & day=year & hour=year*0l & minute=hour & second=hour
year=long('0'+intime)*0l+2l^31 & month=year & day=year & hour=year*0l & minute=hour & second=hour
millisecond=hour & remain=double(hour)
weekday=year & dayofyear=year & week=year & week1=year & week2=year
ampm=hour & century=year & modyear=year

if(not keyword_set(format)) then format='%c'

fmt=format
for i=0l,n_elements(equivalents)/2-1 do begin $
  p=strpos(fmt,equivalents(0,i)) &$
  while(p ge 0) do begin $
    fmt=strmid(fmt,0,p)+equivalents(1,i)+strmid(fmt,p+2,200) &$
    p=strpos(fmt,equivalents(0,i)) &$
  endwhile &$
endfor
fmt1=strcompress(fmt,/rem)

for j=0l,n_elements(intime)-1 do begin
fmt=fmt1
if(not keyword_set(parsepos)) then parsepos=0l
ppos=parsepos
str=strmid(intime(j),ppos,1000)
; not sure what following two lines do, so remove -jhc, 9/04
;i=0l
;while(isspace(strmid(str,i,1)) ne 0) do i=i+1
ppos=ppos+1
str=strtrim(str,2)

num=''
escape=0
i=0l
i2=0l
idum=0l
dum=0d0
while(strlen(fmt) gt 0) do begin $
  char=strmid(fmt,0,1) &$
  if(escape eq 0) then if(char eq '%') then escape=1 $
    else if(char eq strmid(str,i,1)) then i=i+1 else fmt='' $
  else begin $
    if(isdigit(char)) then num=num+char else begin $
      escape=0 &$
      case char of $
        '%': if(char eq strmid(str,i,1)) then i=i+1 else fmt='' &$
        'a': begin $
          weekday(j)=(where(strlowcase(strmid(str,i,3)) eq strlowcase(wkdays)))(0)
          if(weekday(j) lt 0) then fmt='' else begin $
            k=3l &$
            while((k lt strlen(weekdays(weekday(j)))) and $
              (strlowcase(strmid(str,i+k,1)) eq $
               strlowcase(strmid(weekdays(weekday(j)),k,1)))) do k=k+1 &$
            i=i+k &$
          endelse &$
        end &$
        'b': begin $
          month(j)=(where(strlowcase(strmid(str,i,3)) eq strlowcase(mons)))(0) &$
          if(month(j) lt 0) then fmt='' else begin $
            k=3l &$
            while((k lt strlen(months(month(j)))) and $
              (strlowcase(strmid(str,i+k,1)) eq $
               strlowcase(strmid(months(month(j)),k,1)))) do k=k+1 &$
            i=i+k &$
            month(j)=month(j)+1
          endelse &$
        end &$
        'f': begin                ; fractions of seconds (non-standard)
          cap=100l
          if(strlen(num) gt 0) then reads,num,cap
          reads,strmid(str,i,cap+1),dum
          millisecond(j)=long(dum*10d0^(3-cap))
          remain(j)=dum*10d0^(3-cap)-millisecond(j)
          i=i+1
          while((cap gt 0) and (isdigit(strmid(str,i,1)) ne 0)) do begin
            cap=cap-1
            i=i+1
          endwhile
          num=''
        end
        'p': begin
          case strlowcase(strmid(str,i,2)) of
            'am': ampm(j)=1l
            'pm': ampm(j)=2l
            else: fmt=''
          endcase
        end
        'Z': while(isalnum(strmid(str,i,1))) do i=i+1  ; not sure what to do
        else: begin $  ; all other specifications look for digits
          if(isdigit(strmid(str,i,1)) eq 0) then fmt='' $
          else begin $
            reads,strmid(str,i,200),i2,form='(i2)'
            cap=2
            case char of $
              'C': century(j)=i2 
              'd': day(j)=i2 &$
              'H': hour(j)=i2 &$
              'I': hour(j)=i2 &$
              'j': begin
;                reads,strmid(str,i,200),dayofyear,form='(i3)'
                reads,strmid(str,i,200),idum,form='(i3)'
                dayofyear(j)=idum
                cap=3
              end
              'm': month(j)=i2 &$
              'M': minute(j)=i2 &$
              'S': second(j)=i2 &$
              'u': begin
;                reads,strmid(str,i,200),weekday,form='(i1)'
                reads,strmid(str,i,200),idum,form='(i1)'
                weekday(j)=idum
                weekday(j)=weekday(j)-1
                cap=1
              end
              'U': weekofyear(j)=i2 &$
              'V': week2(j)=i2 &$
              'w': begin
;                reads,strmid(str,i,200),weekday,form='(i1)'
                reads,strmid(str,i,200),idum,form='(i1)'
                weekday(j)=idum
                cap=1
              end
              'W': week1(j)=i2 &$
              'y': modyear(j)=i2 &$
              'Y': begin
;                reads,strmid(str,i,200),year,form='(i4)
                reads,strmid(str,i,200),idum,form='(i4)
                year(j)=idum
                cap=4
              end
            endcase &$
            while((cap gt 0) and (isdigit(strmid(str,i,1)) ne 0)) do begin
              cap=cap-1
              i=i+1
            endwhile
          endelse &$
        endelse &$
      endcase &$
    endelse &$
  endelse &$
  fmt=strmid(fmt,1,200) &$
  if(strlen(fmt) gt 0) then while(isspace(strmid(str,i,1)) ne 0) do i=i+1 $
  else ppos=ppos+i
endwhile

; Calculate needed values
if(year(j) eq 2l^31) then if((century(j) ne 2l^31) and (modyear(j) ne 2l^31)) then $
  year(j)=100*(century(j)+1)+modyear(j) $
else if (modyear(j) ne 2l^31) then year(j)=(19+(modyear(j) le 50))*100l+modyear(j)
if(dayofyear(j) ne 2l^31) then if((month(j) eq 2l^31) or (day(j) eq 2l^31)) then begin
  temp=doy2md(dayofyear(j),y=year(j))
  month(j)=temp(0)
  day(j)=temp(1)
endif
if(ampm(j) ne 0l) then hour(j)=hour(j) mod 12+(ampm(j)-1)*12
; Here we probably could figure out month and day if given only the
; year, week of year and day of week, but I'm too lazy now.

; If we still have a need for values, just use values for the present
; time.
if((year(j) eq 2l^31) or (month(j) eq 2l^31) or (day(j) eq 2l^31)) then begin
  tstruct=cvtime(systime(1),from='s1970',to='tstruct')  ; GMT!
  if(year(j) eq 2l^31) then year(j)=tstruct.year
  if(month(j) eq 2l^31) then month(j)=tstruct.month
  if(day(j) eq 2l^31) then day(j)=tstruct.day
endif

endfor

parsepos=ppos

tstruct=replicate({tstruct,year:year(0),month:month(0),day:day(0),hour:hour(0),minute:minute(0), $
                     second:second(0),millisecond:millisecond(0),remain:remain(0), $
                     dayofyear:dayofyear(0),weekday:0l,weekofyear:0l},n_elements(intime))
tstruct.year=year
tstruct.month=month
tstruct.day=day
tstruct.hour=hour
tstruct.minute=minute
tstruct.second=second
tstruct.millisecond=millisecond
tstruct.remain=remain
tstruct.dayofyear=dayofyear

;print,year,month,day,hour,minute,second,millisecond,remain,ampm
;print,weekday,week,week1,week2
;print,century,modyear,dayofyear

return,cvtime(tstruct,from='tstruct',to=rep,round=rnd)

end

; Formatting codes.
;     %%      same as %
;     %a      locale's abbreviated weekday name
;     %A      locale's full weekday name
;     %b      locale's abbreviated month name
;     %B      locale's full month name
;     %c      locale's appropriate date and time representation
; There is a conflict between Solaris and XPG4 over the following
; code.  Here we encode with the first (Solaris) convention, but
; decode with the second convention.  (Decoding seems to have no
; conflict.)
;     %C      locale's date and time representation as produced by
;             date(1)
;     %C      century number (the year divided by  100  and  trun-
;             cated  to  an  integer  as a decimal number [1,99]);
;             single digits are preceded by 0
;     %d      day of month [1,31]; single digits are preceded by 0
;     %D      date as %m/%d/%y
;     %e      day of month [1,31]; single digits are preceded by a
;             space
; Following code is non-standard
;     %[0-9]f fractional seconds including decimal.  Optional number 
;             gives number of digits after decimal point.
;     %h      locale's abbreviated month name
;     %H      hour (24-hour clock) [0,23]; single digits are  pre-
;             ceded by 0
;     %I      hour (12-hour clock) [1,12]; single digits are  pre-
;             ceded by 0
;     %j      day number of year [1,366]; single digits  are  pre-
;             ceded by 0
;     %k      hour (24-hour clock) [0,23]; single digits are  pre-
;             ceded by a blank
;     %l      hour (12-hour clock) [1,12]; single digits are  pre-
;             ceded by a blank
;     %m      month number [1,12]; single digits are preceded by 0
;     %M      minute [00,59]; leading zero is  permitted  but  not
;             required
;     %n      insert a newline
;     %p      locale's equivalent of either a.m. or p.m.
;     %r      appropriate time  representation  in  12-hour  clock
;             format with %p
;     %R      time as %H:%M
;     %S      seconds [00,61]
;     %t      insert a tab
;     %T      time as %H:%M:%S
;     %u      weekday as a decimal number [1,7], with 1 represent-
;             ing Sunday
;     %U      week number of year as  a  decimal  number  [00,53],
;             with Sunday as the first day of week 1
;     %V      week number of the year as a decimal number [01,53],
;             with  Monday  as  the first day of the week.  If the
;             week containing 1 January has four or more  days  in
;             the  new  year, then it is considered week 1; other-
;             wise, it is week 53 of the previous  year,  and  the
;             next week is week 1.
;     %w      weekday as a decimal number [0,6], with 0 represent-
;             ing Sunday
;     %W      week number of year as  a  decimal  number  [00,53],
;             with Monday as the first day of week 1
;     %x      locale's appropriate date representation
;     %X      locale's appropriate time representation
;     %y      year within century [00,99]
;     %Y      year, including the century (for example 1993)
;     %Z      time zone name or abbreviation, or no  bytes  if  no
;             time zone information exists