

enum CARDS {Sunshine, Rain, RosePetalTea}

const DATA = {
	CARDS.Sunshine : 
		{
			"TYPE": "Weather",
			"NAME": "Sunshine",
			"FILE": "sun.png",
			"COST": 0,
			"FLAVOR_TEXT": "What a nice day.",
			"TEXT": "Temperature +3°C.\nSoil humidity -10%.",
		},
	CARDS.Rain : 
		{
			"TYPE": "Weather",
			"NAME": "Rain",
			"FILE": "rain.png",
			"COST": 0,
			"FLAVOR_TEXT": "Some people feel the rain, others just get wet",
			"TEXT": "Temperature -2°C.\nSoil humidity +30%.",
		},
	CARDS.RosePetalTea : 
		{
			"TYPE": "Food",
			"NAME": "Rose Petal Tea",
			"FILE": "rose_tea.png",
			"COST": 2,
			"FLAVOR_TEXT": "Drink tea for good fortune"
		}
}
