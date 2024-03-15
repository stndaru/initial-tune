### Itch.io Page
You can access the game in Itch through [Initial Tune](https://stndaru.itch.io/initial-tune).

> This game is part of the Individual Game Jam for Game Development Course of Universitas Indonesia Computer Science 2023/2024 

---

### Developer Note
Please download the executable for the game to fully experience the game, as the shader is reduced for browser playing. Disclaimer: The VHS effect will make the downloadable version harder to read.

---
# Initial Tune

## Overview
Inspired by Inital D and 90s aesthetics of Japanese Touge (*Mountain Pass*) racing, Initial tune is a retro-themed time-attack racing game. Your main goal is to set the best record time going through the infamous Akina mountain pass, proving yourself to be skillful in clean driving.    

You will not be able to choose or modify your car, but you will have the ability to fine-tune in order to personalize the performance according to your racing style.

**Your tuning and driving skill will be put to the test.**

### Diversifier 1: The Shining Star of Losers Everywhere
You might not be able to defeat the benchmarked time, or perhaps your friend's time. But with each retries, and with each tune changes, you are progressing your time further as you become better in the game.

### Diversifier 2: Us
Although there is a benchmarked time set as a challenge for you to defeat, the one you have to defeat is yourself. With each run, you will need to improve from your time, with each seconds being crucial to beat the end goal. 

### Diversifier 3: MANS NOT HOT
In order to obtain the best laptime, you will have to tune your car. The tuning is set to be as realistic as possible, where you will need to adjust and calculate multiple aspect for the best possible performance.

### Additional Diversifier: Jinx Breaker
You will start with an unvaforable default tune. It is your task to adjust the tune yourself to have a chance in competing for the best possible time.

### Current Best Laptime
Current Best Laptime: 64.37, set by Chamikey.   

## Controls
Controls are currently limited to predefined set that the developers has made. No customization is currently available.    

Gear Up - `LShift`    
Gear Down - `LCtrl`   
Gas - `A/UpArrow`   
Brake - `Z/DownArrow`   
Left - `,/LeftArrow`   
Right - `./Right Arrow`   

> There is gamepad support available, but not recommended in its current state

## Tuning Information
Some few information regarding the tuning if you're not familiar:
#### POWER - Engine Power
The engine power of the car, where higher value means higher power and the faster the car will go
#### FDR - Final Drive Ratio
The Final Drive Ratio of the car gearing system. Lowering the value will affect all gears, where it gives a higher top speed for each gear, but lower acceleration.
#### GR - Gear Ratio
The gear ratio for the car transmission, set for each gear from 1 to 5. Lowering the value will provide lower acceleration, but a higher top speed for each gear. You can read more about it in [LearnDriving Website](https://learndriving.tips/learning-to-drive/how-to-change-gear-in-manual-car/learning-car-gears-faq/car-gear-ratios-explained/).
#### BRK - Brake Power
The brake power of the car. Lower value (higher negative number) means a more powerful braking power.
#### STR - Steering Weight
The steering weight of the car's handling. Lower value means lower height, and higher turning manueverability. Lower this if you experience strong understeering when entering a corner.
#### WGT - Car Weight
The total weight of the car. Lower value means lighter weight, and results in a faster acceleration.

> ProTip - You can get a rough feeling for gear tuning through the [Motoristo](https://motoristo.com/tools/vehicle-speed-calculator?wheelSizeIn=16&tyreWidthMm=225&tyreHeightRatio=45&rpmMax=7000&finalDrive=3&gears=3.3%2C2.25%2C1.75%2C1%2C0.85%2C0.8) website

## Credits and Attribution
### Physics Reference

- https://nccastaff.bournemouth.ac.uk/jmacey/MastersProject/MSc12/Srisuchat/Thesis.pdf 
- https://learndriving.tips/learning-to-drive/how-to-change-gear-in-manual-car/learning-car-gears-faq/car-gear-ratios-explained/ 
- https://gamedev.stackexchange.com/questions/107995/car-game-engine-and-gearbox-calculations 
https://motoristo.com/tools/vehicle-speed-calculator 

### Library and Game Code Reference 

- https://electronstudio.github.io/godot_racing/tutorial.html 
- https://kidscancode.org/godot_recipes/3.x/2d/car_steering/ 

### Other References 

- https://cubic-bezier.com/#.54,.33,.41,1.35 
- https://www.youtube.com/watch?v=PuOB4Jk27sA 

### Theme Inspiration 

- https://www.youtube.com/watch?v=jn0Ac-bu39E 
- https://www.youtube.com/watch?v=5z5yeWYuUSU&-list=PLx9pV6lBAaFN10X9NwvT9AEonqbqK7yuU&index=9 
- https://www.youtube.com/watch?v=fsDXvvIRIy8&t=850s 
- https://www.youtube.com/results?search_query=touge+90s+footage 

### Asset

- [Temporary] AE86 - https://autoartmodels.de/model/78799/ 
- Silver Tuning Board - https://www.freepik.com/free-photo/silver-shimmery-paper-background_3686894.htm#query=white%20metal&position=14&from_view=keyword&track=ais&uuid=6e90a179-06b3-4569-8bba-34947344d447 
- Font - https://www.dafont.com/vcr-osd-mono.font?text=SPEED%3A+740 
- CRT Shader - https://godotshaders.com/shader/vhs-and-crt-monitor-effect/ 
- Map - https://www.racedepartment.com/downloads/akina-2022-yaseone-pass-route-33.53199/ 
- Tilemap Background - Google Earth 
- Speedometer - https://gtaforums.com/topic/701830-wipscriv-1983-1987-toyota-corolla-levinsprinter-trueno-ae85ae86/ 
- Engine Sound - https://www.youtube.com/watch?v=BCcAUhsxbnM 
- Heartbeat - https://pixabay.com/sound-effects/heartbeat-sound-effect-111218/ 

### Music

BGM - https://www.youtube.com/@TurboA 

*Explicit permission from Turbo's YouTube about:* 

>Feel free to use any of my work for your own purposes at your own discretion. I'll have no qualms as long as you give credit where credit is due. I won't claim anything, but that doesn't mean that the authors of the original songs won't.

---

# License
This project is licensed under GNU General Public License v3.0 (GPL).
