extends Боевой_клич
var На_смерть : Array

func боевой_клич(_таргитосе):
	for токен in GameManager.Карты2:
		if токен != я:
			На_смерть.append(токен)
	for токен in GameManager.Карты1:
		if токен != я:
			На_смерть.append(токен)
	for токен in На_смерть:
		токен.смерть()
