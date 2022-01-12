% MAC OSAM Propulsion Sizing
clc; clear;
g0 = 9.80665;
isp = 0;
mass = 0;
m_ratio = 0;
dv_mat_mr = [];
dv_mat_isp = [];
dv_mat_mr_des = [];
dv_des = [];

while isempty(mass) || mass == 0
mass = input('Enter Mass (kg): \n');
end
while isempty(m_ratio) || m_ratio == 0
m_ratio = input('Enter Mass Ratio (M0/Mf): \n');
end
prop = input('Enter Propellant Type:\n 1) Helium\n 2) Hydrogen\n 3) Other\n');
while prop ~= 1 && prop ~=2 && prop ~=3
prop = input('Enter Propellant Type:\n 1) Helium\n 2) Hydrogen\n 3) Other\n');
end
if prop == 1
    isp = 165;
    prop_txt = ('Helium');
  
elseif prop == 2
    isp = 272;
    prop_txt = ('Hydrogen');
elseif prop == 3
    isp = 0;
    while isempty(isp) || isp==0
    prop_txt = input('Enter propellant name:\n','s');
    isp = input('Enter propellant Isp: \n');
    end
end

prop_dens = input('Enter the propellant density (kg/m3): \n');

fprintf('\nUsing the following values:\nMass Ratio: %d\nPropellant Type: %s\nPropellant Isp: %d\n',m_ratio,prop_txt,isp)

dv = log(m_ratio)*isp*(g0/1000);
fprintf('\n Delta V: %f km/s\n',dv)

for ii = 1:0.1:m_ratio
    dv_mat_mr = [dv_mat_mr log(ii)*isp*(g0/1000)];
end
for ii = 0:1:isp
    dv_mat_isp = [dv_mat_isp log(m_ratio)*ii*(g0/1000)];
end

x_mr = 1:0.1:m_ratio;
x_isp = 0:1:isp;

plot(x_mr,dv_mat_mr);
title('Mass ratio vs Delta-V')
xlabel('mass ratio')
ylabel('Delta-V (km/s)')
grid on
figure(2)
plot(x_isp,dv_mat_isp);
title('Isp vs Delta-V')
xlabel('Isp')
ylabel('Delta-V (km/s)')
grid on


dv_des = input('Enter desired dV: \n');
dv_des_save = dv_des;
i = 1;
while true
    dv_it = log(i)*isp*(g0/1000);
    dv_mat_mr_des = [dv_mat_mr_des dv_it];
    
   if dv_it >= dv_des
       break
   else
       i = i+.1;
   end
end
dv_des = [];
for ii = 1:0.1:i
    dv_des = [dv_des log(ii)*isp*(g0/1000)];
end
x_des = 1:0.1:i;
%%%%%
dv_mat_mr_des_hy = [];
j=1;
while true
    dv_it_hy = log(j)*272*(g0/1000);
    dv_mat_mr_des_hy = [dv_mat_mr_des_hy dv_it_hy];
    
   if dv_it_hy >= dv_des_save
       break
   else
       j = j+.1;
   end
end
dv_des_hy = [];
for jj = 1:0.1:j
    dv_des_hy = [dv_des_hy log(jj)*272*(g0/1000)];
end
x_des_hy = 1:0.1:j;
%%%%%
figure(3)
plot(x_des,dv_des)
title('Mass ratio for desired Delta-V')
xlabel('Mass-ratio')
ylabel('Delta-V (km/s)')
grid on

dens_diff = prop_dens/20;
mr_diff = i/max(x_des_hy);

fprintf('Propellant comparison to Hydrogen:\n')
fprintf('%s is %.2g times denser than Hydrogen\n',prop_txt,dens_diff)
fprintf('%s requires %.2g times higher mass ratio to achieve the same (%0.2g km/s) delta-V\n',prop_txt,mr_diff,dv_des_save)

figure(3)
hold on
plot(x_des_hy,dv_mat_mr_des_hy)

%%% Helium
dv_mat_mr_des_he = [];
k=1;
while true
    dv_it_he = log(k)*165*(g0/1000);
    dv_mat_mr_des_he = [dv_mat_mr_des_he dv_it_he];
    
   if dv_it_he >= dv_des_save
       break
   else
       k = k+.1;
   end
end
dv_des_he = [];
for kk = 1:0.1:k
    dv_des_he = [dv_des_he log(kk)*165*(g0/1000)];
end
x_des_he = 1:0.1:k;

%%% Methane
dv_mat_mr_des_me = [];
l=1;
while true
    dv_it_me = log(l)*105*(g0/1000);
    dv_mat_mr_des_me = [dv_mat_mr_des_me dv_it_me];
    
   if dv_it_me >= dv_des_save
       break
   else
       l = l+.1;
   end
end
dv_des_me = [];
for ll = 1:0.1:l
    dv_des_me = [dv_des_me log(ll)*105*(g0/1000)];
end
x_des_me = 1:0.1:l;

%%% Xenon
dv_mat_mr_des_xe = [];
l=1;
while true
    dv_it_xe = log(l)*28*(g0/1000);
    dv_mat_mr_des_xe = [dv_mat_mr_des_xe dv_it_xe];
    
   if dv_it_xe >= dv_des_save
       break
   else
       l = l+.1;
   end
end
dv_des_xe = [];
for ll = 1:0.1:l
    dv_des_xe = [dv_des_xe log(ll)*28*(g0/1000)];
end
x_des_xe = 1:0.1:l+.1;

figure(3)
hold on
plot(x_des_he,dv_mat_mr_des_he,x_des_me,dv_mat_mr_des_me,x_des_xe,dv_mat_mr_des_xe)
legend(prop_txt,'Hydrogen','Helium','Methane','Xenon')

m_hy_fuel = mass-(mass/max(x_des_hy));
m_hy_payload = mass/max(x_des_hy);
m_des_fuel = mass-(mass/i);
m_des_payload = mass/i;
m_he_fuel = mass-(mass/max(x_des_he));
m_he_payload = mass/max(x_des_he);
m_me_fuel = mass-(mass/max(x_des_me));
m_me_payload = mass/max(x_des_me);
m_xe_fuel = mass-(mass/max(x_des_xe));
m_xe_payload = mass/max(x_des_xe);

Type = {'Hydrogen';prop_txt;'Helium';'Methane';'Xenon'};
Fuel_Mass = [m_hy_fuel;m_des_fuel;m_he_fuel;m_me_fuel;m_xe_fuel];
Payload_Mass = [m_hy_payload;m_des_payload;m_he_payload;m_me_payload;m_xe_payload];
Fuel_Volume = [m_hy_fuel/20;m_des_fuel/prop_dens;m_he_fuel/40;m_me_fuel/190;m_xe_fuel/2740];
T = table(Type,Fuel_Mass,Payload_Mass,Fuel_Volume);
disp(T)



