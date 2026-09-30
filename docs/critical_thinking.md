# Critical Thinking

I centered the face using `Offset(size.width / 2, size.height / 2)` and used `size.shortestSide * 0.4` for the radius 
so the face can adjust based on the space available. For the mouth, I used `radius * 1.0` for the width and 
`radius * (0.4 + mood * 0.5)` for the height so changing the mood with the slider can also change the expression. 
I tested the app on the phone emulator in both portrait and landscape and the face stayed centered and fully visible 
without any clipping or overflow, which showed me that using the canvas size and radius instead of fixed positions 
helped make it responsive. My `shouldRepaint` checks if the mood or face type changed because those are the two things 
that can change the drawing, so there is no reason to redraw it if neither one changed.