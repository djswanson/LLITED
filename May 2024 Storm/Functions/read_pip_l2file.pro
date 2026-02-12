function read_pip_l2file, file=file

ncdf_get,file,'.',dat,/struct,/quiet &$
  tagnames=tag_names(dat) &$
  pip1_struct=!null
for i=0,n_tags(dat)-1 do begin
  if(tagnames(i) ne 'CREATED') then begin
    sz=size(dat.(i).value)
    if(sz(0) eq 1) then pip1_struct=create_struct(pip1_struct,tagnames(i),dat.(i).value(0)) $
    else pip1_struct=create_struct(pip1_struct,tagnames(i),dat.(i).value(*,0))
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
pip1=replicate(pip1_struct,dim)
for i=0,n_tags(pip1)-1 do begin $
  ind=(where(tagnames eq (tag_names(pip1))(i)))(0) &$
  pip1.(i)=dat.(ind).value &$
endfor
return, pip1
end
