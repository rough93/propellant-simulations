import math
import numpy as np
import matplotlib.pyplot as plt
import pandas

# Placeholder variables
g0 = 9.80665
isp = 0
mass = 0
m_ratio = 0
dv_mat_mr = []
dv_mat_isp = []
dv_mat_mr_des = []
dv_des = []

mass = int(input('Enter Mass (kg): '))
m_ratio = int(input('Enter Mass Ratio (M0/Mf): '))
prop = int(input('Enter Propellant Type: 1) Helium 2) Hydrogen 3) Other: '))
if prop == 1:
	isp = 165
	prop_txt = 'Helium'
elif prop == 2:
	isp = 272
	prop_txt = 'Hydrogen'
elif prop == 3:
	prop_txt = input('Enter propellant name: ')
	isp = int(input('Enter ' + prop_txt + ' Isp: '))

prop_dens = int(input('Enter ' + prop_txt + ' propellant density (kg/m3): '))

print('Using the following values:')
print('Mass Ratio: ', m_ratio)
print('Propellant Type: ' + prop_txt)
print('Propellant Isp: ', isp)
print('')

dv = math.log(m_ratio)*isp*(g0/1000)
print('Delta-V: ', dv)

for ii in np.arange(1, m_ratio+0.1, 0.1):
	dv_mat_mr.append(math.log(ii)*isp*(g0/1000))

for ii in np.arange(0, isp+1, 1):
	dv_mat_isp.append(math.log(m_ratio)*ii*(g0/1000))

x_mr = np.arange(1, m_ratio+0.1, 0.1)
x_isp = np.arange(0, isp+1, 1)
plt.plot(x_mr, dv_mat_mr)
plt.xlabel('Mass Ratio')
plt.ylabel('Delta-V (km/s)')
plt.title('Mass ratio vs Delta-V')
plt.grid()
plt.show()

plt.figure(num=2)
plt.plot(x_isp, dv_mat_isp)
plt.xlabel('Isp')
plt.ylabel('Delta-V (km/s)')
plt.title('Isp vs Delta-V')
plt.grid()
plt.show()

dv_des = float(input('Enter desired Delta-V: '))
dv_des_save = dv_des

i = 1
while True:
	dv_it = math.log(i)*isp*(g0/1000)
	dv_mat_mr_des.append(dv_it)

	if dv_it >= dv_des:
		break
	else:
		i += 1

dv_des = []

for ii in np.arange(1, i+0.1, 0.1):
	dv_des.append(math.log(ii)*isp*(g0/1000))

x_des = np.arange(1, i+0.1, 0.1)

dv_mat_mr_des_hy = []
dv_hy_copy = []
j = 1
while True:
	dv_it_hy = math.log(j)*272*(g0/1000)
	dv_mat_mr_des_hy.append(dv_it_hy)

	if dv_it_hy >= dv_des_save:
		break
	else:
		j += 0.1
dv_mat_mr_des_hy.append(math.log(j+0.1)*272*(g0/1000))

dv_des_hy = []
for jj in np.arange(1, j+0.1, 0.1):
	dv_des_hy.append(math.log(jj)*272*(g0/1000))
x_des_hy = np.arange(1, j+0.1, 0.1)

plt.figure(num=3)
plt.plot(x_des, dv_des)
plt.xlabel('Mass Ratio')
plt.ylabel('Delta-V (km/s)')
plt.title('Mass Ratio for Desired Delta-V')
plt.grid()
plt.show()

dens_diff = prop_dens/20
mr_diff = i/max(x_des_hy)

print('Propellant comparison to Hydrogen:')
print(prop_txt + ' is ' + str(dens_diff) + ' times denser than Hydrogen')
print(prop_txt + ' requires ' + str(mr_diff) + ' times higher mass ratio to achieve the same Delta-V (' + str(dv_des_save) + 'km/s)')

plt.figure(num=3)
plt.plot(x_des_hy, dv_mat_mr_des_hy)

# Helium
dv_mat_mr_des_he = []
k = 1
while True:
	dv_it_he = math.log(k)*165*(g0/1000)
	dv_mat_mr_des_he.append(dv_it_he)

	if dv_it_he >= dv_des_save:
		break
	else:
		k += 0.1
dv_mat_mr_des_he.append(math.log(k+0.1)*165*(g0/1000))

dv_des_he = []
for kk in np.arange(1, k+0.1, 0.1):
	dv_des_he.append(math.log(kk)*165*(g0/1000))
x_des_he = np.arange(1, k+0.1, 0.1)
plt.figure(num=3)
plt.plot(x_des_he, dv_mat_mr_des_he)

#Methane
dv_mat_mr_des_me = []
l = 1
while True:
	dv_it_me = math.log(l)*105*(g0/1000)
	dv_mat_mr_des_me.append(dv_it_me)

	if dv_it_me >= dv_des_save:
		break
	else:
		l += 0.1
dv_mat_mr_des_me.append(math.log(l+0.1)*105*(g0/1000))

dv_des_me = []
for ll in np.arange(1, l+0.1, 0.1):
	dv_des_me.append(math.log(ll)*105*(g0/1000))
x_des_me = np.arange(1, l+0.1, 0.1)
plt.figure(num=3)
plt.plot(x_des_me, dv_mat_mr_des_me)
plt.legend([prop_txt, 'Hydrogen', 'Helium', 'Methane'])

m_hy_fuel = mass-(mass/max(x_des_hy))
m_hy_payload = mass/max(x_des_hy)
m_des_fuel = mass-(mass/i)
m_des_payload = mass/i
m_he_fuel = mass-(mass/max(x_des_he))
m_he_payload = mass/max(x_des_he)
m_me_fuel = mass-(mass/max(x_des_me))
m_me_payload = mass/max(x_des_me)



data = [['Hydrogen', m_hy_fuel, m_hy_payload, m_hy_fuel/20 ],
[prop_txt, m_des_fuel, m_des_payload, m_des_fuel/prop_dens ],
['Helium', m_he_fuel, m_he_payload, m_hy_fuel/40 ],
['Methane', m_me_fuel, m_me_payload, m_hy_fuel/190 ]]
headers = ["Propellant", "Fuel Mass", "Payload Mass", "Fuel Volume"]

print(pandas.DataFrame(data, headers, headers))
