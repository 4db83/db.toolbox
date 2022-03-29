function [] = no_rotation(ind)

SetDefaultValue(1,'ind',1);

if ind == 1
  set(groot,'defaultAxesXTickLabelRotationMode','manual')
else 
  set(groot,'defaultAxesXTickLabelRotationMode','remove')
end

end