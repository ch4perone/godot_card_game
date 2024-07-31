

enum CARDS {Sunshine, Rain, RosePetalTea}

const DATA = {
	CARDS.Sunshine : 
		{
			"TYPE": "Weather",
			"NAME": "Sunshine",
			"FILE": "sun.png",
			"COST": 0,
			"FLAVOR_TEXT": "What a nice day.",
			"TEXT": "Increases temperature by 3°C\nDecreases soil humidity by 10%",
		},
	CARDS.Rain : 
		{
			"TYPE": "Weather",
			"NAME": "Rain",
			"FILE": "rain.png",
			"COST": 0,
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
