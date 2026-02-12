function read_migsi_l2file, file=file

; read MIGSI files
; jhc, 2/2024
;

ncdf_get,file,'.',dat,/struct,/quiet &$
tagnames=tag_names(dat) &$
migsi1_struct=!null
for i=0,n_tags(dat)-1 do begin
  if(tagnames(i) ne 'CREATED') then begin
    sz=size(dat.(i).value)
    if(sz(0) eq 1) then migsi1_struct=create_struct(migsi1_struct,tagnames(i),dat.(i).value(0)) $
    else migsi1_struct=create_struct(migsi1_struct,tagnames(i),dat.(i).value(*,0))
  endif
endfor
dim=0
i=0
repeat begin 
  if(tagnames(i) ne 'CREATED') then begin
    sz=size(dat.(i).value)
    dim=sz(sz(0))
  endif
  i++
endrep until(dim gt 0)
migsi1=replicate(migsi1_struct,dim)
for i=0,n_tags(migsi1)-1 do begin $
  ind=(where(tagnames eq (tag_names(migsi1))(i)))(0) &$
  migsi1.(i)=dat.(ind).value &$
endfor

return,migsi1
end
