wheelRadius = 1.5;
wheelThickness = .5;
wheelShellThickness = .25;
wheelFaceThickness = .1;
outerFaceradius = wheelRadius-0.1;

axleDiameter = 0.2;

numHoles = 0;

numSpokes = 0;
spokeWidth = .25;
spokeOffsetPer = 1;

eps = 0.0001;
verts = 50;

module wheel()
{
union()
{
    difference(){
        // outer wheel
        union()
        {
            cylinder(h=wheelFaceThickness, r2=wheelRadius, r1=outerFaceradius, $fn=verts);
            
            tmpThickness = wheelThickness-wheelFaceThickness;
            
            translate([0,0,wheelFaceThickness])
            cylinder(h=wheelThickness, r=wheelRadius, $fn=verts);
        }

        difference(){
            // inner wheel space
            innerRadius = wheelRadius-wheelShellThickness;
            shellHeight = wheelThickness+1;
            
            if(numSpokes == 0)
            {
                translate([0, 0, wheelShellThickness+eps])
                cylinder(h=shellHeight+2, r=innerRadius, $fn=verts); 
            }
            else
            {
                translate([0, 0, -1])
                cylinder(h=shellHeight+2, r=innerRadius, $fn=verts); 
            }
            
            // inner axle shell
            innerAxleShell = wheelShellThickness+(axleDiameter/2);
            cylinder(h=shellHeight+3, r=innerAxleShell, $fn=verts);
        }
        
        axleHoleDepth = wheelThickness + 2;
        
        translate([0,0,-1])
        cylinder(h=axleHoleDepth, d=axleDiameter, $fn=verts);
        
        if(numHoles > 0)
        {
            halfRadius = wheelRadius/2;
            holeBuffer = wheelRadius*.1;
            holeDiameter = ((2*PI*halfRadius)/numHoles)-holeBuffer;
            maxHoleDiameter = wheelRadius - (wheelShellThickness*2) - (holeBuffer*2);
           
            for(rot=[0:360/numHoles:360])
            {
                echo("rotate");
                echo(rot);
                
                if(holeDiameter > maxHoleDiameter)
                {
                    rotate(rot) translate([0,halfRadius,-1]) cylinder(h=axleHoleDepth, d=maxHoleDiameter, $fn=30);
                }
                else
                {
                    rotate(rot) translate([0,halfRadius,-1]) cylinder(h=axleHoleDepth, d=holeDiameter, $fn=30);
                }
            }
        }
    }

    if(numSpokes > 0)
    {
        intersection()
        {
            // create spokes
            for(rot=[0:360/numSpokes:360])
            {
                spokeLength = wheelRadius;//(outerFaceradius - (axleDiameter/2))*0.99;
                rotate(a=rot)
                translate([0,-spokeWidth*spokeOffsetPer/2,0])
                //translate([axleDiameter/2,0,0])
                cube([spokeLength,spokeWidth, wheelShellThickness]);
            }
            
            // make sure the spokes don't stick out of the rim
            difference()
            {
                cylinder(h=wheelThickness, r=outerFaceradius, $fn=verts);
                
                translate([0,0,-1])
                cylinder(h=wheelThickness+2, d=axleDiameter+eps, $fn=verts/2);
            }
        }
    }
}
}

// over row 1
translate([distance,-distance,0])
wheel(numSpokes = 2, spokeOffsetPer=0, spokeWidth=wheelRadius);

translate([0,-distance,0])
wheel(numSpokes = 10, spokeOffsetPer=0);

translate([-distance,-distance,0])
wheel(numSpokes = 5, spokeOffsetPer=0);

translate([-distance*2,-distance,0])
wheel(numSpokes = 2, spokeOffsetPer=0);

// center row
distance = (wheelRadius*2) * 1.05;

wheel(numSpokes = 10);

translate([-distance,0,0])
wheel(numSpokes = 5);

translate([-distance*2,0,0])
wheel(numSpokes = 2);

translate([distance,0,0])
wheel(numHoles = 5);

translate([distance*2,0,0])
wheel(numHoles = 4);

translate([distance*3,0,0])
wheel(numHoles = 3);

translate([distance*4,0,0])
wheel(numHoles = 2);

// under row 1
translate([0,distance,0])
wheel(numSpokes = 10, spokeWidth=.5);

translate([-distance,distance,0])
wheel(numSpokes = 3, spokeWidth=.75);

translate([-distance*2,distance,0])
wheel(numSpokes = 2, spokeWidth=1);

singleWidth = (wheelShellThickness*2) + axleDiameter;

translate([distance,distance,0])
wheel(numSpokes = 1, spokeWidth=singleWidth);

// under row 2
translate([0,distance*2,0])
wheel(numSpokes = 10, spokeWidth=.4, spokeOffsetPer=0);

translate([-distance,distance*2,0])
wheel(numSpokes = 3, spokeWidth=.75, spokeOffsetPer=0);

translate([-distance*2,distance*2,0])
wheel(numSpokes = 2, spokeWidth=1, spokeOffsetPer=0);

singleWidth = (wheelShellThickness*2) + axleDiameter;

translate([distance,distance*2,0])
wheel(numSpokes = 1, spokeWidth=singleWidth, spokeOffsetPer=0);
