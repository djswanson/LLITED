function read_IRI, file=file

  ncdf_get,file,'.',dat,/struct,/quiet &$
    tagnames=tag_names(dat) &$
    IRI_struct=!null
  for i=0,n_tags(dat)-1 do begin
    if(tagnames(i) ne 'CREATED') then begin
      sz=size(dat.(i).value)
      if(sz(0) eq 1) then IRI_struct=create_struct(IRI_struct,tagnames(i),dat.(i).value(0)) $
      else IRI_struct=create_struct(IRI_struct,tagnames(i),dat.(i).value(*,0))
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
  IRI=replicate(IRI_struct,dim)
  for i=0,n_tags(IRI)-1 do begin $
    ind=(where(tagnames eq (tag_names(IRI))(i)))(0) &$
    IRI.(i)=dat.(ind).value &$
  endfor
return, IRI
end
