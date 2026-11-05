%[text] # Electric Charges and Electric Fields 
%[text] [⇦ Main Menu](file:../MainMenu.m)
%[text] Electric charges and fields are at the heart of electromagnetism,  explaining everything from static cling to lightning. In this lesson,  we'll use MATLAB to visualize and compute electric fields, making these  invisible forces more tangible and easier to understand. 
%[text:tableOfContents]{"heading":"Table of Contents"}
%%
%[text] %[text:anchor:H_BF646A47] This live script is intended to be used with the code hidden. On the **View** tab of the MATLAB toolstrip, in the **View** section, select **Hide Code**.  Alternately, select **Hide Code** using the icon ![live script code hidden icon](text:image:34a3) at the top right of the Live Editor pane.
%[text] ![Lightbulb mark](text:image:0449) Although the code is hidden, some interactivity requires familiarity with MATLAB. If you need more instruction, consider taking [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted), a free 2 hour online tutorial that teaches the essentials of MATLAB.
%[text] %[text:anchor:H_8F8A032D] ![Warning symbol](text:image:08bd)   For an optimal experience, follow the instructions and steps in the given sequence. Proceed to a new section only after completing the preceding one. Some sections depend on variables created in prior sections and will generate errors if run out of order.
%[text] The ![Try this icon](text:image:6bc9)  and  ![Exercise icon](text:image:57d8) icons refer to two different types of interactive activities that you will find in this script. The ![Try this icon](text:image:2365)  usually indicates an interaction where you will explore the visualization of some concept introduced in this script. The ![Exercise icon](text:image:4c13) interactions are designed to challenge your understanding of those concepts and may be used for grading and completion checks by your professor.
%%
%[text] ## Electric Charge and Coulomb Force 
%[text] Electric charge is a property of matter that causes it to experience a force when placed in an electromagnetic field. Charges are either positive or negative, and like charges repel while opposite charges attract.
%[text] Given two point charges $A$ and $B$ in space, each charge exerts a force on the other: $\\vec{F}\_{A\\rightarrow B}$ and $\\vec{F}\_{B\\rightarrow A}$.
%[text] The force between a point charge $A$ (with charge $q\_A$) and a point charge $B$ (with charge $q\_B$) is described by Coulomb's law, which can be expressed in different forms:
%[text]{"align":"center"} %[text:anchor:M_1276] $ \\vec{F\_{B\\rightarrow A}} = k\_e \\frac{q\_A q\_B}{r^3}\\vec{r}\_{B\\rightarrow A} \\qquad(1)$
%[text]{"align":"center"} $ \\vec{F\_A} = k\_e \\frac{q\_A q\_B}{r^2}{\\hat{r}}\_{B\\rightarrow A} \\qquad(2)$
%[text]{"align":"center"} $ \\vec{F\_A}\n = \\frac{1}{4\\pi\\varepsilon\_0}\\frac{q\_A q\_B}{r^3}\\vec{r}\_{B\\rightarrow A} \\qquad(3)$
%[text]{"align":"center"} $ \\vec{F\_A} = \\frac{1}{4\\pi\\varepsilon\_0}\\frac{q\_A q\_B}{r^2}{\\hat{r}}\_{B\\rightarrow A} \\qquad(4)$
%[text] Note that the four expressions above are equivalent, with:
%[text] - $k\_e$ is the Coulomb constant, which can be expressed as a function of the vacuum electric permittivity $\\varepsilon\_0$: $k\_e=\\frac{1}{4\\pi\\varepsilon\_0}=8.987\\times10^9 \\quad (\\text{N}\\cdot\\text{m}^2\\cdot\\text{C}^{-2})$
%[text] - $\\vec{r}\_{B\\rightarrow A}$ is the displacement vector from $B$ to $A$, $r = ||\\vec{r}\_{B\\to A}||$ is its magnitude, and ${\\hat{r}} = \\frac{\\vec{r}\_{B\\to A}}{r}$ its unit vector \
%[text] ![decorative](text:image:28df) **Info.** All of Coulomb's law forms expressed above are equivalent; depending on the textbook you are using, you might see one of those or even a slightly different one.
%[text] 
%[text] ![decorative](text:image:2793) **Try.** Using the slider and spinner below, visualize the force between a charge particle $A$ $(+1 \\text{ mC})$ and a charged particle $B$ of varying charge at different distances:
%[text] - You might end up in situation where the force is so small that you can't even see the arrow, in this case try using logarithmic scale or the zoom tool ![decorative](text:image:3bfd).
%[text] - The position of the charges will change depending on the distance. \

PlotCoulombForce(5,... %[control:spinner:69ff]{"position":[18,19]}
    1.4,... %[control:slider:0fe7]{"position":[5,8]}
    false) %[control:checkbox:79e2]{"position":[5,10]}

function PlotCoulombForce(Charge,rTest,logScale)
% Define parameters for the charges and distance
Charge = Charge*1e-3;
TestCharge = 1e-3;
k_e = 8.99e9; % Coulomb's constant in N*m^2/C^2

% Calculate the Coulomb force
Theta = linspace(0,3.5*2*pi);
r = 5/(7*pi)*Theta;
ThetaTest = 7*pi/5*rTest;
xTest = rTest*cos(ThetaTest);
yTest = rTest*sin(ThetaTest);
Fx = k_e * abs(Charge * TestCharge) / rTest^2 * cos(ThetaTest);
Fy = k_e * abs(Charge * TestCharge) / rTest^2 * sin(ThetaTest);
F = sqrt(Fx^2+Fy^2);
if logScale
    lquiver = log(F/180); % Magic number to scale the length
else
    lquiver = F/9000; % Magic number to scale the length
end

figure
scatter(0,0,"filled",SeriesIndex=1,DisplayName="B")
hold on
scatter(rTest*cos(ThetaTest),rTest*sin(ThetaTest),"filled",SeriesIndex=2,DisplayName="A")
quiver(0,0,-sign(Charge)*lquiver*cos(ThetaTest),-sign(Charge)*lquiver*sin(ThetaTest),SeriesIndex=1,DisplayName="F_B",AutoScale="off",MaxHeadSize=5)
quiver(xTest,yTest,sign(Charge)*lquiver*cos(ThetaTest),sign(Charge)*lquiver*sin(ThetaTest),SeriesIndex=2,DisplayName="F_A",AutoScale="off",MaxHeadSize=5)
hold off

if F > 1000
    F = F /1000;
    title(sprintf("Coulomb Force = %.1f kN",F))
else
    title(sprintf("Coulomb Force = %.0f N",F))
end

ylim([-5 5])
axis equal
axis off

legend(location="bestoutside")
end
%%
%[text] ![](text:image:6f0d) **Reflect.** In the previous interaction, you might have noticed that even with a larger distance and smaller charge, the force can be quite strong. This is because a charge on the order of magnitude of mC is considered to be a very large charge. For reference, the charge of an electron is $q\_e = 1.602 \\times 10^{-19} \\,\\text{C}$
%%
%[text] ![](text:image:727c) **Exercise 1.** Based on the [formulas above](internal:M_1276), and your observation, complete the sentence below:
CheckExercise1([],[],[])  %[control:dropdown:27fe]{"position":[16,18]} %[control:dropdown:72e1]{"position":[19,21]} %[control:dropdown:47a2]{"position":[22,24]} %[control:button:2cb8]{"position":[25,26]}
function CheckExercise1(forceTrend,distTrend,rate)
err = false;
if sign(forceTrend)*sign(distTrend) == 1
    err = true;
    warning("Re-run the interaction above, did the force increase or decrease as the distance increased?")
end
if rate ~= 2
    err = true;
    warning("Look closely at equation (2) and (4), because they use the unit vector r, it makes it easier to read the rate.")
end
if ~err
    disp("Good job! You are fluent in Coulomb force!")
end
end
%%
%[text] ![](text:image:7312) **Exercise 2.** Use the [live control below](internal:M_8850) to generate a problem statement and solve the problem. You can use the edit field below to enter your answer in Newton, or even type your mathematical formula (you can even use `k_e` in the edit field for the Coulomb constant).
  %[control:button:279d]{"position":[1,2]}
Prob2 = GenerateProblemStatement2; %[text:anchor:M_8850]

function y = GenerateProblemStatement2()
Charge = [-5:-1 1:5];
Charge = Charge(randi(10));
PosTest = (randi([0 1])-0.5)*randi([1 9])/5;

u = symunit;
syms q A B
displayFormula('"Consider the following charge distribution:"')
displayFormula(["A" '": a point charge with ("' "q == Charge" '" "' "u.C" '") located at the origin of the coordinate system."'])
displayFormula(["B" '": a point charge with ("' "q == 1" '" "' "u.C" '") located at ("' sprintf('%.1d',PosTest) ' ' "u.m" '" ) along the x-axis."'])
displayFormula(['"What is the magnitude and direction of the force acting on the charge "' "B" '"?"'])

y.ID = "Ex2";
y.Charge = Charge;
y.Position = PosTest;
end
%%
if exist("Prob2","var")
    CheckExercise2(Prob2,...
        "",... %[control:editfield:75da]{"position":[9,11]}
        0 ... %[control:dropdown:3ea0]{"position":[9,10]}
         ) %[control:button:596e]{"position":[9,10]}
else
    warning("Click generate problem above to generate a problem statement.")
end

function CheckExercise2(Prob,Answer,Direction)

% Check that it is the right exercise
if ~contains(Prob.ID,"Ex2")
    warning("Click 'Generate Problem' above to generate a problem statement.")
    return
end

if (Answer == "") || (Direction == 0)
    warning("Please select two valid answers above.")
    return
end

% Check Answer
k_e = "8.99e9";
Answer = replace(Answer,"k_e",k_e);
Answer = double(str2sym(Answer));
RightAnswer = 8.99e9*abs(Prob.Charge)/Prob.Position^2;

if sign(Answer) == -1
    warning("The magnitude of the force should be positive (You could use the abs() function to get the absolute value)")
end
if IsClose(Answer,abs(RightAnswer))
    disp("Good job! You computed the magnitude of the force correctly.")
else
    warning("The magnitude of the force is wrong, double check that your expression matches one of the formulas above.")
end

% Check Direction
if sign(Prob.Charge)*sign(Prob.Position) ~= sign(Direction)
    warning("The direction you picked is wrong. Try again!")
else
    if Direction == 1
        disp("Good job! The direction of the force is along the positive direction of the x-axis.")
    else
        disp("Good job! The direction of the force is along the negative direction of the x-axis.")
    end
end
end
%%
%[text] ![MATLAB icon](text:image:3e14) **Pro-tip.** While the Coulomb force might be new to you, it is similar to the gravitational force in that it follows an inverse-square law $\\left(\\frac{1}{r^2}\\right)${"altText":"(1\/r^2)"}. However, they differ in several key aspects: the Coulomb force is significantly stronger and can be either attractive or repulsive, depending on the charges involved, whereas the gravitational force is always attractive and acts solely between masses.
%[text:table]{"ignoreHeader":true}
%[text] | **Electrostatic Forces** | $\\vec{F\_A} = k\_e \\frac{q\_A q\_B}{r^2} \\hat{{r}}\_{B\\rightarrow A}$ |
%[text] | --- | --- |
%[text] | **Gravitational Forces** | $\\vec{F\_A} = -G \\frac{m\_A m\_B}{r^2} \\hat{{r}}\_{B\\rightarrow A}\n$ |
%[text:table]
%[text] ## Relationship between Electric Charges and Electric Fields 
%[text] The concept of an electric field is essential to describing and understanding how charges interact at a distance without direct contact. Like a gravitational field, which simplifies the interaction between masses by using a constant field ($\\vec{g}$) to describe the force per unit mass ($\\vec{F}=m\\vec{g}$), the electric field provides a framework to understand the force experienced by a charge in the presence of other charges. This abstraction allows us to calculate the force on any charge by simply multiplying the charge by the electric field strength ($\\vec{F}=q\\vec{E}$), much like using ($\\vec{F}=m\\vec{g}$) for gravitational forces. 
%[text] ![Warning symbol](text:image:30b2) **Warning.** The major difference between ($\\vec{F}=q\\vec{E}$) and ($\\vec{F}=m\\vec{g}$) is that usually a constant gravitational field is assumed to be constant ($\\vec{g}$), while electric fields are generally going to vary in space.
%[text] Based on the Coulomb force, we can express the electric field generated by a single charged particle (with charge $q$) as a function of position centered around the particle:
%[text]{"align":"center"} %[text:anchor:M_8581]  $ \\vec{E} = k\_e \\frac{q}{r^2}{\\hat{r}}\\qquad (5)$
%[text] With:
%[text] - $k\_e$ is the Coulomb constant and is can be expressed as a function of the vacuum electric permittivity $\\varepsilon\_0$: $k\_e=\\frac{1}{4\\pi\\varepsilon\_0}=8.987\\times10^9 \\quad (\\text{N}\\cdot\\text{m}^2\\cdot\\text{C}^{-2})$
%[text] - $r$ is the distance to the particle, and ${\\hat{r}}$ the unit vector from the particle \
%[text] ![](text:image:9b70) **Try.** Using the live control below, visualize the electric field by a particle of with different amounts of charge, using different plotting functions. 
%[text] - Some visualizations show only the field strength, while others show both strength and direction. Choose the view that best matches what you want to investigate.
%[text] - ![Warning symbol](text:image:7ee0) Some of the visualizations might look broken. Looking with a logarithmic scale might help; otherwise, we'll get to why they look broken in the next exercise. \
if ~exist("MemSingleChargeField","var")
    MemSingleChargeField = [];
end


MemSingleChargeField = SingleChargeField(MemSingleChargeField,Charge=2,LogScale=true,... %[control:spinner:5a71]{"position":[70,71]} %[control:checkbox:4d56]{"position":[81,85]}
    Method="Filled Contour"); %[control:dropdown:4816]{"position":[12,28]}
%%
clear MemSingleChargeField
%%
function Mem = SingleChargeField(Mem,opts)
arguments
    Mem
    opts.Charge (1,1) double = 1
    opts.LogScale (1,1) logical = true
    opts.Method (1,1) string = "Contour"
    opts.Reset (1,1) logical = false
end

% Retrieve argument
Method = opts.Method;
Charge = opts.Charge;
LogScale = opts.LogScale;

% Generate a persistent location for the charge
if isempty(Mem)
    [posCharge] = randi([-3,3],1,2);
    xCharge = posCharge(1);
    yCharge = posCharge(2);
    Mem.xCharge = xCharge;
    Mem.yCharge = yCharge;
else
    xCharge = Mem.xCharge;
    yCharge = Mem.yCharge;
end


% Create a grid of points for visualization
switch Method
    case "??"
        warning("Select a valid visualization method.")
        return;
    case "Vector"
        NumPoints = 20;
    case "Contour"
        NumPoints = 400;
    case "Filled Contour"
        NumPoints = 400;
    case "Surface"
        NumPoints = 40;
end

% Compute the field on the grid
[xGrid, yGrid] = meshgrid(linspace(-5,5,NumPoints),linspace(-5,5,NumPoints));
rx = xGrid - xCharge;
ry = yGrid - yCharge;
r = sqrt(rx.^2 + ry.^2);
Charge = Charge*1e-3; % Change charge from microCoulomb to Coulomb
k_e = 8.99e9; % Coulomb's constant in N*m^2/C^2
Ex = k_e * Charge/1000 * rx ./ r.^3;
Ey = k_e * Charge/1000 * ry ./ r.^3;
E = sqrt(Ex.^2 + Ey.^2);
dirx = Ex./E;
diry = Ey./E;
if LogScale
    E = log10(E);
end

% Create the figure
figure
if Method == "Surface"
    scatter3(xCharge,yCharge,max(E(:)),"filled",SeriesIndex=2,DisplayName="Charge")
else
    scatter(xCharge,yCharge,"filled",SeriesIndex=2,DisplayName="Charge")
end
hold on
switch Method
    case "Vector"
        quiver(xGrid,yGrid,E.*dirx,E.*diry,AutoScale="on",DisplayName="E Field")
    case "Contour"
        contour(xGrid,yGrid,E,30,DisplayName="E Field")
        cb = colorbar(location="westoutside");
        if LogScale
            Ticks = cb.TickLabels;
            Ticks = convertCharsToStrings(Ticks);
            Ticks = 10.^(double(Ticks));
            cb.TickLabels = num2str(Ticks,'%.1e');
        end
    case "Filled Contour"
        contourf(xGrid,yGrid,E,50,DisplayName="E Field",LineStyle="none")
        cb = colorbar(location="westoutside");
        if LogScale
            Ticks = cb.TickLabels;
            Ticks = convertCharsToStrings(Ticks);
            Ticks = 10.^(double(Ticks));
            cb.TickLabels = num2str(Ticks,'%.1e');
        end
    case "Surface"
        surf(xGrid,yGrid,E,DisplayName="E Field")
        if LogScale
            ax = gca;
            Ticks = ax.ZTickLabels;
            Ticks = convertCharsToStrings(Ticks);
            Ticks = 10.^(double(Ticks));
            ax.ZTickLabels = num2str(Ticks,'%.1e');
        end
end
hold off

title("Electric Field Generated by a single charge")
xlabel('x (m)');
ylabel('y (m)');
axis equal
legend(Location="bestoutside")
xlim([-5 5])
ylim([-5 5])

end

%%
%[text] ![](text:image:87a5) **Exercise 3.** What happens to the electric field strength as we get close to the point charge?
%%
  %[control:button:72b3]{"position":[1,2]}
HintExercise3

function HintExercise3()
displayFormula(['"In one dimension, the magnitude of the Coulomb force will look like this:"'])
figure
x = linspace(0,5,1000);
y = 1./(x-2.5).^2;
plot(x,y)
ylim([-100 1000])
ax = gca;
ax.YTick = 0;
ax.XTick = 2.5;
ax.XTickLabel{1} = "Charge Location";
title("Unitless magnitude Coulomb force")
end
%%
CheckExercise3([])  %[control:dropdown:2fc4]{"position":[16,18]} %[control:button:5bb0]{"position":[19,20]}
function CheckExercise3(Answer)
if isempty(Answer)
    warning("Please, select an answer")
    return
end

switch Answer
    case 0
        warning("Incorrect. As you approach a point charge, the electric field strength does not decrease to zero.")
    case 1
        warning("Incorrect. The electric field strength changes with distance from a point charge and does not remain constant.")
    case 2
        disp("Correct! As you get closer to a point charge, the electric field strength increases and theoretically approaches infinity.")
end

end
%%
%[text] ![](text:image:49cb) **Exercise 4.** Use the [live control below](internal:M_0ea9) to generate a problem statement and solve the problem. You can use the edit field below to enter your answer in Newtons, or even type your mathematical [formula](internal:M_8581) (use `k_e` in the edit field for the Coulomb constant).
Prob4 = GenerateProblemStatement4;  %[control:button:0ae7]{"position":[35,36]} %[text:anchor:M_0ea9]

function y = GenerateProblemStatement4()
Charge = [-5:-1 1:5];
Charge = Charge(randi(10));
Position = randi([1 5]);
%  fprintf("What is the electric field magnitude felt ( d = %i m)\naway from a point charge (q = %+i C).",Position,Charge)
u = symunit;
displayFormula(['"What is the magnitude of an electric field "' "Position" '" "' "u.m" '" "'; '"away from a point charge with "' "q == Charge" '" "' "u.C" '"?"'])
y.ID = "Ex4";
y.Charge = Charge;
y.Position = Position;
end
%%
CheckExercise4(Prob4," " ) %[control:editfield:7e18]{"position":[23,24]} %[control:button:5958]{"position":[25,26]}

function CheckExercise4(Prob,Answer)
% Check that it is the right exercise
if ~contains(Prob.ID,"Ex4")
    warning("Click generate problem above to generate a problem statement.")
    return
end

% Check Answer
k_e = "8.99e9";
Answer = replace(Answer,"k_e",k_e);
Answer = double(str2sym(Answer));
RightAnswer = 8.99e9*abs(Prob.Charge)/Prob.Position^2;
if sign(Answer) == -1
    warning("The magnitude of the electric field should be positive.")
end
if IsClose(Answer,abs(RightAnswer))
    disp("Good job! You computed the magnitude of the force correctly.")
else
    warning("The answer you entered is not correct, make sure that you are using the right formula for the electric field.")
end
end
%%
%[text] ## What if I have more than one charge?
%[text] What about electric fields that are generated by multiple charges? To picture this, think of a cat playing in a box of packing peanuts. When it comes out, static electricity makes the peanuts stick all over its fur each one pulled by the electric charges involved. Similarly, rubbing a balloon on your hair causes the strands to stand up and cling to the balloon. When multiple charges are present, each one influences all the others, creating a complex electric field.
%[text] ### **Superposition Principle**
%[text] The superposition principle states that the total electric field created by multiple charges is the vector sum of the electric fields produced by each charge individually. Mathematically, if $\\vec{E}\_1$, $\\vec{E}\_2$, ..., $\\vec{E}\_n$ are the electric fields due to individual charges, then the total electric field $\\mathbf{E}\_{\\text{total}}$ is given by: 
%[text]{"align":"center"} $ \\vec{E}\_{\\text{total}} = \\vec{E}\_1 + \\vec{E}\_2 + \\cdots + \\vec{E}\_n $ 
%[text] This principle is crucial when dealing with systems of multiple charges, as it allows the calculation of the resultant field by considering each charge separately. 
%[text] ![](text:image:394d) **Try.** Visualize the electric field due to multiple charges in space. The charge values (in Coulombs) and their locations in space will be randomized, and you can use the reset button to return the charges and their positions to their initial state.
if ~exist("MemPlotFieldMulti","var")
    MemPlotFieldMulti = [];
end
MemPlotFieldMulti = PlotFieldMulti(MemPlotFieldMulti,NumCharge=5);   %[control:spinner:1738]{"position":[64,65]} %[control:button:4c4f]{"position":[68,69]}
%%
  %[control:button:260e]{"position":[1,2]}
clear MemPlotFieldMulti
%%
function Mem = PlotFieldMulti(Mem,opts)
arguments
    Mem
    opts.NumCharge (1,1) double = 4
end

NumCharge = opts.NumCharge;

% Generate memory variable
if isempty(Mem) || opts.NumCharge ~= length(Mem.xCharge)
    [posCharge] = randi([-3,3],NumCharge,2);
    Mem.xCharge = posCharge(:,1);
    Mem.yCharge = posCharge(:,2);
    Charges = [-5:-1 1:5];
    Mem.Charges = Charges(randi(10,NumCharge,1)')*1e-3;
end

% Retrieve memory variable
xCharge = Mem.xCharge;
yCharge = Mem.yCharge;
Charges = Mem.Charges;

% Compute electric field
[xGrid, yGrid] = meshgrid(linspace(-5,5,400),linspace(-5,5,400));
k_e = 8.99e9; % Coulomb's constant in N*m^2/C^2
Ex = zeros(size(xGrid));
Ey = zeros(size(yGrid));
for i = 1:NumCharge
    rx = xGrid - xCharge(i);
    ry = yGrid - yCharge(i);
    r = sqrt(rx.^2 + ry.^2);
    Ex = Ex + k_e * Charges(i) * rx ./ r.^3;
    Ey = Ey + k_e * Charges(i) * ry ./ r.^3;
end
E = sqrt(Ex.^2 + Ey.^2);
E = log10(E);

% Plot results
figure
contourf(xGrid,yGrid,E,40,DisplayName="Electric Field",LineStyle="none")
cb = colorbar(location="westoutside");
Ticks = cb.TickLabels;
Ticks = convertCharsToStrings(Ticks);
Ticks = 10.^(double(Ticks));
cb.TickLabels = num2str(Ticks,'%.1e');
hold on
Marker = replace(linestyleorder("mixedmarkers"),"-","");
for i = 1:NumCharge
    scatter(xCharge(i),yCharge(i),Marker{i},SeriesIndex='none',DisplayName=sprintf("Charge %i (%+i mC)",i,Charges(i)*1000))
end
hold off

title("Electric Field Generated by "+NumCharge+" Charges")
xlabel('x (m)');
ylabel('y (m)');
axis equal
legend(Location="bestoutside")
xlim([-5 5])
ylim([-5 5])

end
%%
%[text] ![](text:image:1c39) **Exercise 5.** Use the live control below to generate a problem statement and solve the problem. You can use the edit field below to enter your answer in V/m, or even type your mathematical formula (you can even use `k_e` in the edit field for the Coulomb constant).
Prob5 = GenerateProblemStatement5;  %[control:button:5e95]{"position":[35,36]}

function y = GenerateProblemStatement5()
Number = [-5:-1 1:5];
y.ID = "Ex5";
y.Charge1 = Number(randi(10));
y.Charge2 = Number(randi(10));
y.Position1 = Number(randi(10))/10;
y.Position2 = Number(randi(10))/10;
% fprintf("Considering the following point charge distribution:\n")
% fprintf("  - (q = %+i C) located at %+.1f m from the origin on the x-axis\n",y.Charge1,y.Position1)
% fprintf("  - (q = %+i C) located at %+.1f m from the origin on the x-axis\n",y.Charge2,y.Position2)
% fprintf("What is the strength of the electric field at the origin?")

u = symunit;
displayFormula('"Considering the following point charge distribution:"')
displayFormula(['"  Charge 1: "' "q == y.Charge1" '" "' "u.C" '" located at "' sprintf('%.1d',y.Position1) '" "' "u.m" '"from the origin on the x-axis"';...
    '"  Charge 2: "' "q == y.Charge2" '" "' "u.C" '" located at "' sprintf('%.1d',y.Position2) '" "' "u.m" '"from the origin on the x-axis"'])
displayFormula('"What is the magnitude of the electric field at the origin?"')
end
%%
CheckExercise5(Prob5,"" ) %[control:editfield:6088]{"position":[22,24]} %[control:button:69dd]{"position":[24,25]}

function CheckExercise5(Prob,Answer)
% Check that it is the right exercise
if ~contains(Prob.ID,"Ex5")
    warning("Click generate problem above to generate a problem statement.")
    return
end

% Check Answer
k_e = "8.99e9";
Answer = replace(Answer,"k_e",k_e);
Answer = double(str2sym(Answer));
RightAnswer = 8.99e9*(Prob.Charge1/Prob.Position1^2+Prob.Charge2/Prob.Position2^2);
if sign(Answer) == -1
    warning("The magnitude of the force should be positive."+...
        " You could use the abs() function to retrieve the magnitude of your answer.")
    return
end
if IsClose(Answer,abs(RightAnswer))
    fprintf("Good job! You computed the magnitude of the force correctly.\n")
    fprintf("  - E ≈ %.2e V/m",RightAnswer)
else
    warning("The answer is not correct. Recheck the electric field magnitude and direction.")
end
end
%%
%[text] ![MATLAB icon](text:image:86bc) **Pro-tip.** The superposition principle is one of the principal tools that allows us to compute electrical fields. Instead of trying to solve a large, complex problem, we can break down the problem into contributions from different parts of the system and then add them all up together.
%[text] ![](text:image:041a) **Application.** To understand how the superposition principle helps solve complex problems, check out the [capacitor script series](file:CapacitorsFundamentals.m). It explains how the principle applies to capacitors.
%%
%[text] ## Electric Fields Due to Continuous Charge Distributions 
%[text] When dealing with electric fields generated by discrete point charges, we can apply Coulomb's law to find the field at a specific point in space by considering each charge's contribution. However, in many real-world scenarios, charges are distributed continuously over a region, such as along a line, over a surface, or throughout a volume. In these cases, the concept of an electric field becomes more complex, and we turn to calculus for help. Using integrals, we can calculate the electric field due to a continuous charge distribution by summing up the infinitesimally small contributions from each tiny charge element across the entire distribution. This approach allows us to account for the cumulative effect of all the charged elements, providing a more comprehensive understanding of the electric field in such situations.
%[text] ### First Example: Random Line in Space
%[text] In this section, we will compute the field generated by a random line with continuous charges in a 2D space step by step.
%[text] ![](text:image:4fcd) **Try.** Click the button below to generate a random line in space
   %[control:button:34d3]{"position":[1,2]}
Prob6 = GenerateRandomLine;

function Prob = GenerateRandomLine()
figure
Theta = 2*pi*randi(15)/15;
xLine = linspace(-10,10,400);
yLine = 0.1*xLine.^3+0.02*0.02*xLine.^2-2*xLine;
Rot = [cos(Theta), -sin(Theta);sin(Theta) cos(Theta)];
Line = Rot*[xLine;yLine];
xLine = Line(1,:);
yLine = Line(2,:);
id= xLine < 5 & xLine > -5 & yLine < 5 & yLine > -5;
xLine = xLine(id);
yLine = yLine(id);
plot(xLine,yLine)
axis square
xlim([-5 5])
ylim([-5 5])
Prob.xLine = xLine;
Prob.yLine = yLine;
Prob.ID = "GenerateLine";
end

%%
%[text] We will approximate the line by discretizing it into multiple segments that will be modeled as discrete points in space. 
%[text] ![](text:image:9ec4) **Try.** Break it down into segments where the points represent the centroid of each segment, discretizing the line.
if ~exist("Prob6","var")
    warning("Before to discretize the line, you need to create it with the interaction above.")
else
    Prob6 = BreakDownLine(Prob6,8);    %[control:spinner:2fd4]{"position":[33,34]} %[control:button:6c2e]{"position":[38,39]}
end

function Prob = BreakDownLine(Prob,NumSeg,NoPlot)
arguments
    Prob (1,1)
    NumSeg (1,1)
    NoPlot = false
end

if ~contains(Prob.ID,"GenerateLine")
    warning("First you should generate a line with the interaction above.")
    return
end

dist = cumsum(sqrt([0 diff(Prob.xLine)].^2 + [0 diff(Prob.yLine)].^2));
distPt = linspace(1/(2*NumSeg)*dist(end),(1-1/(2*NumSeg))*dist(end),NumSeg);
id = floor(interp1(dist,1:length(dist),distPt));
Prob.xPt = Prob.xLine(id);
Prob.yPt = Prob.yLine(id);
Prob.Length = dist(end);
Prob.NumSegment = NumSeg;
if ~NoPlot
    figure
    plot(Prob.xLine,Prob.yLine)
    hold on
    scatter(Prob.xPt,Prob.yPt,'filled')
    axis square
    xlim([-5 5])
    ylim([-5 5])
end
if ~contains(Prob.ID,"_BreakDown")
    Prob.ID = Prob.ID+"_BreakDown";
end
end
%%
%[text] Now that we have simplified the geometry into a set of points, we need to assign an appropriate charge to each of those points.
%[text] ![](text:image:7f1d) **Exercise 6.** Use the live control below to generate and solve a problem.
  %[control:button:777c]{"position":[1,2]}
if ~exist("Prob6","var")
    warning("Before to attempt this exercise, please run the interaction above to create and discretize the line.")
else
    Prob6 = GenerateProblemStatement6(Prob6);
end

function Prob = GenerateProblemStatement6(Prob)
if ~contains(Prob.ID,"BreakDown")
    warning("First you should break the line into multiple segment using the interaction above.")
    if contains(Prob.ID,"GenerateLine")
        Prob = BreakDownLine(Prob,8);
    end
    return
end
if ~isfield(Prob,"Lambda")
    Lambda = [-0.5:0.1:-0.1 0.1:0.1:0.5];
    Prob.Lambda = Lambda(randi(length(Lambda)));
end

ApproxLambda = round(vpa(Prob.Lambda,6),1); %#ok<NASGU>
ApproxLength = round(vpa(Prob.Length,6),1); %#ok<NASGU>
u = symunit; %#ok<NASGU>

displayFormula(['" The line charge density is "' "lambda == ApproxLambda" '" "' "u.C/u.m" '"."'; ...
    '" The line is approximately "' "L == ApproxLength" '" "' "u.m" '" long."';...
    '"If the line is broken down into "' "Prob.NumSegment" '" "' "" '"segments. What is the charge on each segment?"'])
if ~contains(Prob.ID,"_Ex6")
    Prob.ID = Prob.ID +"_Ex6";
end
end
%%
Prob6 = CheckExercise6(Prob6," " ); %[control:editfield:42d1]{"position":[31,32]} %[control:button:2eb5]{"position":[33,34]}

function Prob = CheckExercise6(Prob,Answer)
if ~contains(Prob.ID,"Ex6")
    warning("First you should generate a problem statement above.")
    return
end

RightAnswer = sprintf("%.1f * %.1f / %i",Prob.Lambda,Prob.Length,Prob.NumSegment);
RightAnswer = double(str2sym(RightAnswer));
Answer = double(str2sym(Answer));

if IsClose(Answer,RightAnswer)
    disp("Good job! You computed the equivalent individual charges correctly.")
    Prob.Solved = true;
else
    warning("Try again! The individual charge should be a function of λ, L and the number of segments.")
end

end
%%
%[text] ![](text:image:3da8) **Try.** Use superposition to compute the field.
PlotLineField(Prob6);  %[control:button:47e2]{"position":[21,22]}

function PlotLineField(Prob)
if ~contains(Prob.ID,"Ex6")
    warning("First you should solve the exercise above.")
    return
end

% Define parameters for the charges and distance
k_e = 8.99e9; % Coulomb's constant in N*m^2/C^2

% Create a grid of points for visualization
[xGrid, yGrid] = meshgrid(linspace(-5,5,400),linspace(-5,5,400));
% Initialize electric field components
Ex = zeros(size(xGrid));
Ey = zeros(size(yGrid));

% Compute electric field components due to charge Q1
Charge = Prob.Lambda*Prob.Length/Prob.NumSegment;
for i = 1:Prob.NumSegment
    dx = xGrid - Prob.xPt(i);
    dy = yGrid - Prob.yPt(i);
    r = sqrt(dx.^2 + dy.^2);
    Ex = Ex + k_e * Charge * dx ./ r.^3;
    Ey = Ey + k_e * Charge * dy ./ r.^3;
end

E = sqrt(Ex.^2 + Ey.^2);
E = log10(E);

figure
contourf(xGrid,yGrid,E,30,DisplayName="Field",LineStyle="none")
cb = colorbar;
Ticks = cb.TickLabels;
Ticks = convertCharsToStrings(Ticks);
Ticks = 10.^(double(Ticks));
cb.TickLabels = num2str(Ticks,'%.1e');
hold on
plot(Prob.xLine,Prob.yLine)
scatter(Prob.xPt,Prob.yPt,'filled')
hold off
axis square
xlim([-5 5])
ylim([-5 5])

end
%%
%[text] ![](text:image:844d) **Try.** Use the live control below to repeat the step above with more points to more finely discretize the line.
Prob6 = BreakDownLine(Prob6,3,true); %[control:slider:3a71]{"position":[29,30]}
PlotLineField(Prob6);
%%
%[text] ![](text:image:8390) **Reflect.** How many segments would you need to accurately represent an electric field?
%%
%[text] In the previous problem, we considered a 1D distribution of charge. Although the problem was in a 2D (x-y) plane, the distribution was along a line (1D). 
%[text] ![](text:image:8314) **Exercise 7.** Use the live control below to generate a problem statement and solve the problem. You can use the edit field below to enter your answer in Newton, or even type your mathematical formula (you can even use `k_e` in the edit field for the Coulomb constant).
  %[control:button:7905]{"position":[1,2]}
Prob7 = GenerateProblemStatement7;

function Prob = GenerateProblemStatement7()
% Generate problem statement
Prob.ID = "Ex7";
Prob.Dimension = randi(3); % Problem dimension
u = symunit;
switch Prob.Dimension
    case 1
        Prob.Letter = sym("lambda");
        Prob.Unit = u.C/u.m;
        Prob.Shape = "segment";
        Prob.DimName = "length";
    case 2
        Prob.Letter = sym("sigma");
        Prob.Unit = u.C/u.m^2;
        switch randi(2)
            case 1
                Prob.Shape = "square";
                Prob.DimName = "length";
            case 2
                Prob.Shape = "disk";
                Prob.DimName = "radius";
        end
    case 3
        Prob.Letter = sym("rho");
        Prob.Unit = u.C/u.m^3;
        switch randi(2)
            case 1
                Prob.Shape = "cube";
                Prob.DimName = "length";
            case 2
                Prob.Shape = "sphere";
                Prob.DimName = "radius";
        end
end
Prob.Length = 2:0.2:4;
Prob.Length = Prob.Length(randi(length(Prob.Length)));
Prob.Charge = 2:0.2:4;
Prob.Charge = Prob.Charge(randi(length(Prob.Charge)));

% Display problem statement
ApproxCharge = round(vpa(Prob.Charge,6),1);
ApproxLength = round(vpa(Prob.Length,6),1);
switch randi(2)
    case 1 % Compute total charge
        Prob.Case = "Total";
        displayFormula(['"Consider a distribution on a "' 'Prob.Shape' '" of "' 'Prob.DimName' '" "' "ApproxLength" '" "' "u.m" '", with a charge density "' "Prob.Letter == ApproxCharge" '" "' "Prob.Unit" '"."'])
        displayFormula('"What is the total charge contained in this distribution?"')
    case 2 % Compute charge density
        Prob.Case = "Density";
        displayFormula(['"Consider a distribution on a "' 'Prob.Shape' '" of "' 'Prob.DimName'  " "' "ApproxLength" '" "' "u.m" '", with a total charge of "' "ApproxCharge" '" "' "u.C" '"."'])
        displayFormula('"What is the charge density of this distribution?"')
end
end
%%

CheckExercise7(Prob7,"" ) %[control:editfield:849f]{"position":[22,24]} %[control:button:0803]{"position":[24,25]}

function CheckExercise7(Prob,MyAnswer)

if ~contains(Prob.ID,"Ex7")
    warning("First you should generate a problem statement above.")
    return
end

if MyAnswer == ""
    warning("Please complete your answer.")
    return
else
    MyAnswer = double(str2sym(MyAnswer)); % Convert the user's answer to a numeric value
end

switch Prob.DimName
    case "length"
        switch Prob.Dimension
            case 1
                Surface = Prob.Length;
            case 2
                Surface = Prob.Length^2;
            case 3
                Surface = Prob.Length^3;
        end
    case "radius"
        switch Prob.Dimension
            case 2
                Surface = pi*Prob.Length^2;
            case 3
                Surface = 4/3*pi*Prob.Length^3;
        end
end

switch Prob.Case
    case "Total"
        Answer = Prob.Charge * Surface;
        CommonWrong = Prob.Charge / Surface;
        if IsClose(Answer,MyAnswer)
            disp("Good job! You computed the total charge correctly. Generate and new problem statement and try again!")
        else
            if IsClose(CommonWrong,MyAnswer)
                warning("The formula you used to compute the total charge is wrong."+newline+...
                    "Hint: your computation would have been correct for charge density")
            else
                warning("Your computation is wrong, try again!")
            end
        end
    case "Density"
        Answer = Prob.Charge / Surface;
        CommonWrong = Prob.Charge * Surface;
        if IsClose(Answer,MyAnswer)
            disp("Good job! You computed the charge density correctly. Generate and new problem statement and try again!")
        else
            if IsClose(CommonWrong,MyAnswer)
                warning("The formula you used to compute the charge density is wrong."+newline+...
                    "Hint: your computation would have been correct for total charge")
            else
                warning("Your computation is wrong, try again!")
            end
        end
end
end
%%
%[text] This approach of breaking down the problem into smaller pieces can be very useful, but sometimes the problem can also be solved using tools from calculus!
%[text] ![](text:image:201d) **Exercise 8.** What calculus tool can you think of to calculate some of these without going to an infinite number of segments?
CheckExercise8("??") %[control:dropdown:8657]{"position":[16,20]}

function CheckExercise8(MyAnswer)
switch MyAnswer
    case "??"
        warning("Please select a valid answer.")
    case "Derivative"
        warning("Useful for finding the rate of change, but not for directly computing electric fields from charge distributions.")
    case "Integral"
        disp("Correct! Integrals are used to sum contributions from charge elements to find the total electric field.")
    case "Series"
        warning("Series help approximate functions but aren't typically used for calculating electric fields from charge distributions.")
    case "Fourier Analysis"
        warning("Useful for frequency decomposition, but not the primary method for computing electric fields from charge distributions.")
end
end
%%
%[text] ### Second Example: A Finite Charged Line
%[text] In this example, we solve for the electric field using calculus and use MATLAB to represent the field.
%[text] ![](text:image:310c) **Try.** We are considering a finite length vertical charged line with a uniform charge density ($\\lambda$). Use the slider below to define the length of the line.
ProbEnd = DrawFiniteLine(3.9);  %[control:slider:8fee]{"position":[26,29]} %[control:button:930c]{"position":[31,32]}
%[text] 

function Prob = DrawFiniteLine(L,EnablePlot)
arguments
    L (1,1)
    EnablePlot (1,1) logical = true;
end

Prob.ID = "DrawLine";
Prob.Length = L;
Prob.Lambda = 1.0;

if EnablePlot
    figure
    y = linspace(-L/2,L/2,2);
    x = 0.*y;
    plot(x,y,LineWidth=4,SeriesIndex=4,DisplayName="Charge Distribution")
    legend(Location="bestoutside")
    axis square
    xlim([-5 5])
    ylim([-5 5])
end

end
%%
%[text] Consider a line of charge extending from $y=-\\frac{L}{2}${"altText":"y=-L\/2"} to $y=\\frac{L}{2}${"altText":"y=L\/2"} along the $y$-axis. Let the linear charge density be $\\lambda$ (charge per unit length). We aim to find the electric field at any point ($P$) located at a distance $x$ from the $y$-axis on the $x$-axis.
%[text]{"align":"center"} ![](text:image:401e)
%[text] Choose a small element charge $dq$ located at a distance $h$ from the center of the line. The differential charge is given by:
%[text]{"align":"center"} $dq = \\lambda dh$
%[text] The electric field due to the differential charge $dq$ at the point $P$ can be expressed using Coulomb's Law. The distance from $dq$ to $P$ is:
%[text]{"align":"center"} $r = \\sqrt{x^2+(y-h)^2}$
%[text] The differential electric field $d\\vec{E}$ due to $dq$ is:
%[text]{"align":"center"} $d\\vec{E}=k\_e\\frac{dq}{r^2}\\hat{r}$
%[text] The electric field has both $x$ and $y$ components:
%[text]{"align":"center"} $d{E\_x}=k\_e\\frac{dq}{r^3}x = k\_e \\frac{\\lambda dh\\,x}{(x^2+(y-h)^2)^{3/2}}$
%[text]{"align":"center"} $d{E\_y}=k\_e\\frac{dq}{r^3}(y-h) = k\_e \\frac{\\lambda (y-h) dh}{(x^2+(y-h)^2)^{3/2}}$
%[text] Integrate over the length of the line:
%[text]{"align":"center"} $E\_x= \\frac{k\_e \\lambda}{2x} \\left( \\frac{L+2y}{\\sqrt{x^2 + (L/2+y)^2}} + \\frac{L-2y}{\\sqrt{x^2 + (L/2-y)^2}} \\right)$
%[text]{"align":"center"} $E\_y= k\_e\\lambda \\left( \\frac{1}{\\sqrt{x^2+(y-L/2)^2}} - \\frac{1}{\\sqrt{x^2+(y+L/2)^2}} \\right)$
%[text] 
%[text]{"align":"center"} 
%%
%[text] ![](text:image:97e3) **Try.** Visualize the answer. 
  %[control:button:4d6e]{"position":[1,2]}
if ~exist("ProbEnd","var")
    warning("Solving the problem with line of length 1 m.")
    ProbEnd = DrawFiniteLine(1,false);
end
PlotFieldFiniteLine(ProbEnd);
function PlotFieldFiniteLine(Prob)

k_e = 8.999e9;
lambda = Prob.Lambda;
L = Prob.Length;
Ex = @(x,y) k_e*lambda * 1./(2.*x) .* ( (L+2*y)./sqrt(x.^2 + (L/2+y).^2) + (L-2*y)./sqrt(x.^2 + (L/2-y).^2) );
Ey = @(x,y) k_e*lambda * ( 1./sqrt(x.^2 + (y-L/2).^2) - 1./sqrt(x.^2 + (y+L/2).^2) );

[xGrid,yGrid] = meshgrid(linspace(-5,5,400),linspace(-5,5,400));
E = sqrt(Ex(xGrid,yGrid).^2 + Ey(xGrid,yGrid).^2);
figure
contourf(xGrid,yGrid,log10(E),30,LineStyle="none",DisplayName="E Field")
hold on
y = linspace(-L/2,L/2,2);
x = 0.*y;
plot(x,y,LineWidth=1,SeriesIndex=4,DisplayName="Charge Distribution")
hold off

cb = colorbar(location="westoutside");
Ticks = cb.TickLabels;
Ticks = convertCharsToStrings(Ticks);
Ticks = 10.^(double(Ticks));
cb.TickLabels = num2str(Ticks,'%.1e');

legend (location="bestoutside")
axis square
xlim([-5 5])
ylim([-5 5])
end
%%
%[text] ![](text:image:31ec) **Note.** What happens when the line becomes very long? What happens when the line becomes very short? (How does it compare to a discrete point charge?)
ProbEnd = DrawFiniteLine(3.601,false); %[control:slider:2c89]{"position":[26,31]}
PlotFieldFiniteLine(ProbEnd);
%%
%[text] ## Further Exploration
%[text] In this script, you had many interactions creating visualizations of electric fields. If you would like to learn how to visualize an electric field in MATLAB, you should complete VisualizeField.m.
%%
%[text] ## Conclusion 
%[text] In this lesson, we examined the relationship between electric charges and electric fields. We covered the superposition principle and learned how to compute electric fields from point charges and continuous charge distributions. Visualizing the Coulomb force and electric fields helped us gain a clearer and more intuitive understanding of these concepts. Grasping these ideas is key to analyzing a wide range of physical phenomena in electromagnetism, and it sets a solid foundation for further exploration in the field.
%%
function tf = IsClose(A,B)
    lhs = abs(A-B);
    rhs = max(1e-4,1e-4*max(abs(A),abs(B)));
    tf = lhs <= rhs;
end
%[text] 
%[text] [⇦ Main Menu](file:../MainMenu.m)
%%
%[text] ## Help us Improve
%[text] [Share your feedback](<matlab: ShareFeedback>) to help us improve this module.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"hidecode","rightPanelPercent":40}
%---
%[text:image:34a3]
%   data: {"align":"middle","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAArElEQVR42mP4\/\/8\/AwgnJiYapKamfgfS\/ynBUDMMYOYywBggiYcPH\/6nFIDMAJmFYQHIdmoBqFm4LZjrYPd\/gpoyGIPYVLeA5j4gbEASHJNlwZYtW\/93dHTixDCDQTRMDKRn8FhATBDNmTOH\/CAiBI4cOQI2HETTLBW9fv2a\/FRUtPXVf\/WeuyRhkB6iLQBp2HLvP0kYpGfUglELhpMFNM9oNKlw6FHp06TZAgAoeVix9Bg9oQAAAABJRU5ErkJggg==","width":24}
%---
%[text:image:0449]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+SvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+E+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoqKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzvAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0DShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoCB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1eqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btHJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCOriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjtVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/ASgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysrFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNxk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:08bd]
%   data: {"align":"baseline","height":23,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAEp0lEQVR42t2a208TQRTG67OJxvv9fiGoD6LGgPiCGo1G\/wljTKDl1pL00RuKIKCIIiKg6ItB8IJ38K4Panz13RcfSBBBQQHRek4ys\/kYpu1uu2132+Sku6eb6X7zmzlz5ux6PEn6lJaWbi0uLu4mGyLrJWvMz8+f4UmnjxA5QhZS7HNZWdnUdNE5hQR9EsLGioqKWuj7kRRbUlJSmS40D4Co4yD+rfAPEdW5rhdKQj4KQQM4J0n0DhjCVW4XuR9oHlV\/J98rSZVsnmuF0nz8oNIsLCxcFQwGp4vf86AjzrhV5D4dTTq+Tr8d0VD95fP5Frpx2L4XAgYlTQpMq+n8DxKm4+0wV6tdJZIo7YWbPwbi26QfqdL5S+H\/7SqqdMPvJE2iOFPOTUEzpM5bpEodUOMWkXs06yb7r6qZEc5dOn\/hKqqQCESiOYkqic4Ff62jRZKg3XCzJ0B8q0akjupzSZU6aZGTl5Q34kZ\/BgKB2ezzer3LOMcNJ5SpSvJIlY7POTWn3QUBpRzEt0QQqYvMzxxNlW7staRJQ3gO0Bw1IdSYz9Qx28Bf57QhuxNu7iSIbzYhclKEpvZ6HElVR5OOl5qkGZEqdcB5p9DMC0OzyYJIXaTuFr4R6rzFTkj3jK1WHDRDarSmdnPAX59qkbkQaU+B\/7IqglM7+g4qVqu5rhzaeeoIqpC2RaVJN52pGfYbdFRlW0iVrr2QcppkFSC+MUxUNSt0AlU6f5JSqpCuGcUtv9+\/JExZ05JQpErf2eC\/mOxIi4v6aRDfEGGdtCJUjeCPhW+Uk5BkCu2xQjNGoQZVWl+30Pk\/4W9I1tzM0RWfeVhFyXysCp0QyaHoPUZtLU\/G3OxWadIfL+Dilt1CMZrTtZuB6qVE7zezdUVnDv0mctlYhKpUHyaFKoR6SzTjEYr\/pVBtTDhNLDZz0m1ydxKrUHWdfiCp+ny+FYmgKUP8sHx8YJamDUK1VDnVtHs5wSFTDeLrLOw34xGqrtf3E0IVgoBRiiwoKJhvlqZNQjEubIKOb7Jr3TQaxeIyF6+sbMFsEKqu2\/ZShQZVmsPJFhqOKrVzxTaaWFTW7SNNCD3IlUI08h2KYXOO63eXpErtrYwnCHWpNDniWqVpsxlUacnLAhDNsa6bWTqaolIQSrFVwei6FxdVGlZ3baY5SNav2KCdVLlYblXkRqB5FnqvOlYKNgWjUJjsTEIZpzbXWIm0d9QCMlfneI\/oFKFKhoZgWs0GIP7zv+qDHu7BeOZVAoSqWZqEM+73+9eaodlpN80ECjXiBwLih87Rnoith4vrgGZlvJEyQUJVqrdNUaULOmRp0U6a8uUMssNo\/BDYBqHDnKlppt21qDTxwQ7vGhywbkbrxBrN1Bsny9DRbFcLxV6vdxad\/3C6UJyryvRrU7OgdfBjPYivcIHIkCYX79BSpZObLqYZkSq\/kicjaqZ04oMcrpS7SGRIzeJIy60JVDk6SZpcbRdDeRr5v2hyU6fbV\/l8VVlXm5lcX0wJsTveYpMVw14PzMOGNBQqE4h+3M8x5hti3UwH64S52y6D0YALA49Z6+P3hCXiDLH2fEsjgd+ZKr9wyRr\/A+UKAPezYlA8AAAAAElFTkSuQmCC","width":23}
%---
%[text:image:6bc9]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:57d8]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:2365]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:4c13]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:28df]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+SvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+E+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoqKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzvAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0DShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoCB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1eqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btHJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCOriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjtVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/ASgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysrFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNxk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:2793]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:3bfd]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACIAAAAiCAIAAAC1JZyVAAAACXBIWXMAABYlAAAWJQFJUiTwAAAFfElEQVRIie2W23LaShaG1TqCThwCQhziYASFScqJcy5zkTfJu+TBcpdKJQWVVEhsBxMIVohBRmAhQBJCrdZcKONxZbyxK7tmai6m7+jVrY+1+l9\/NwiCAPvPD\/y\/wPg\/5n8aQ17+EQQBhNB13fV67fs+QugiBAAgCIKiKIZhGIb5c0wQBKvVSlXVZrPZ6XTOzs5s20YIBUGA43gkEkmlUoqi3L9\/\/+nTpziOAwBujgFh3yCEDMM4Ojo6Pj7WNI2iqGg0ynEcx3EYhjmOY9u2bdue5wmCsLOzU6vVZFkmSfK671\/KBiFkmubXr1\/fvn07nU4FQdje3r5z504ulxNFkSTJxWKhaZqqqt1udzAYaJrmOM7+\/n4ikbghCQRBoOt6q9VqtVrz+bxSqezt7SUSCZ7nWZYlSRIAACEMEzIM4\/v37+\/fvycIolarvXjxQpIkHL9eR+RyuVRV9fj4eD6fV6vVhw8fKopCEAQAwPf9Xq+HEJIkSRRFlmXj8XgsFnNd9+Dg4OjoKJfL0TQdi8UIgtjAsG2bHA6HnU7HMIx0Ov348ePbt2\/TNB2GLctqNBoQwv39\/Xg8jmEYQRCpVOrZs2eWZX3+\/LnT6QiCQNM0z\/MbMOPxGP\/58+fp6SnLssViMZ\/Psyx7EYYQjsfj8CQuJimKkmVZURRJkjRNGwwGlmVtrpimafh0Ol0ul+l0emtr6yKPXwUlSZIkKYr6rfoAAFmWS6XSarWaTqeu627GGIaBW5bl+34qlcpkMgRB+L7vuq7ruhBCCCGGYUEQ+L7ved56vXZd1\/M8AMCtW7fy+XwQBKHKN2McxyEhhDiOx+PxRCKBEDo7OxuNRjiOMwxjmuZsNoMQqqoa6i0IglDuPM9LkkRRFITwsllcOSCEJIZhYTPSND2bzZrN5uvXr2maJggCIWRZVhAEhmGEX8QwTFGUly9fxmIxQRAoirqhF5Chj4X\/lKbpYrFYr9cpiiJJ0rbtg4MDhFCpVEqn0yEmlUqFnrZarW6Syi8MQRAQQsMwDMOIxWIPHjzY3d0NY7Ztm6bpeV69Xr979244CQDAcdy2bV3X1+s1QRDXtieO42QkEgEATKdTXdfDOlzeFgRBaJ2XTSUIAtM0R6NRWIDNvYlhGMMweDqdFkVR13VVVX+TJkIoFJjv+7\/Nj0ajfr8vimI2m41Go5sxyWQSLxQKuVxusVj0+\/2wDhdhAADHcTzPUxR1kYfneefn591udzgcZrPZYrG42QIwDJNlmSwUCqZpTiaT4XD48eNH3\/cVRQn1E41Gnz9\/jhDKZDLhBt\/3dV1\/9+5dq9WCEG5vb+fz+Ugkcj1GEIStrS1d1w8PD9vtNoTQ87xkMsmyLMMwOzs74dLlcuk4zvn5ea\/XazQaw+FQkiSEEADgWk1zHEe8evWKoqjw+tI0bTweTyaT9XodHglJkhcHfnJycnh42Ol0bNvG\/mlF0WiU53mapjfDSAzDIpFIoVAInebk5GQ6nXqeNxgMOI5LJpMAgMViMZ\/PLcuyLIthmEePHq1Wq8lkoqpqePmWy2We5zeQfsmUJMlcLheLxYbDYa\/X6\/f7P378cBwHgF+3OMMwyWSyVCopirK9vb1ardrt9ps3b759++Z5HkKoWq2yLPtXPfSvbiAIQhCEYrHIcZwsy7PZzHVd3\/fDvmEYRhTFVColSZIgCOEW0zS\/fPmiqmr4AimXy6IoXokBf\/xURwhpmtZoND58+OA4TrVardfrtVrtyoRu+jT594HjuCzLT548iUQizWaz2+2yLEvTdKVSuWLxH2NCkiRJ9+7d29vbkyTp9PT006dPV6\/8OxgMwyiKymQyu7u75XJ5uVy22+0rl\/150cIBAKBpOpvNsixbqVT+6qT\/AXFD9uzT\/SdoAAAAAElFTkSuQmCC","width":20}
%---
%[control:spinner:69ff]
%   data: {"defaultValue":1,"label":"Charge of B (mC)","max":5,"min":-5,"run":"Section","runOn":"ValueChanged","step":1}
%---
%[control:slider:0fe7]
%   data: {"defaultValue":1,"label":"Distance from A to B (m)","max":5,"min":0.5,"run":"Section","runOn":"ValueChanged","step":0.1}
%---
%[control:checkbox:79e2]
%   data: {"defaultValue":false,"label":"Use Logarithmic Scale","run":"Section"}
%---
%[text:image:6f0d]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+SvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+E+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoqKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzvAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0DShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoCB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1eqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btHJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCOriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjtVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/ASgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysrFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNxk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:727c]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:dropdown:27fe]
%   data: {"defaultValue":"[]","itemLabels":["??","increases","decreases"],"items":["[]","1","-1"],"label":"The force ","run":"Nothing"}
%---
%[control:dropdown:72e1]
%   data: {"defaultValue":"[]","itemLabels":["??","increases","decreases"],"items":["[]","1","-1"],"label":"as the distance ","run":"Nothing"}
%---
%[control:dropdown:47a2]
%   data: {"defaultValue":"[]","itemLabels":["??","linear rate","quadratic rate","cubic rate"],"items":["[]","1","2","3"],"label":"at a ","run":"Nothing"}
%---
%[control:button:2cb8]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:7312]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:279d]
%   data: {"label":"Generate Problem Statement","run":"Section"}
%---
%[control:editfield:75da]
%   data: {"defaultValue":"\"\"","label":"Force magnitude","run":"Nothing","valueType":"String"}
%---
%[control:dropdown:3ea0]
%   data: {"defaultValue":"0","itemLabels":["??","Along positive direction x-axis","Along negative direction x-axis"],"items":["0","1","-1"],"label":"Direction","run":"Nothing"}
%---
%[control:button:596e]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:3e14]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB8AAAAcCAYAAACZOmSXAAACP0lEQVR42mNgoCLIy8vzys\/Pf15QUNDNQE9QWFioBLT4CxD\/B2GgA5LoZjnQwi0wi6H4TVlZGS89LA5FsxiGK2hqcW5urijQkidAfA+L5S\/S0tJYaWU3I9CCjUC8GYg\/YfM9MBH60yq4G6GW1OEIdhBeT1VLQUEJNLQDavg2IJ6Kx\/IfwJQvQLGlDQ0NbECDsoEGXoEa\/BUYrDpA+gMey0FBH0+RxdnZ2fJAg26gGVwKdEwBPouheCslFgsDDbiDZuC2kpISbiD9lAjLfwILISFyE9YKNMPugwxDSnDE4GSiLQwNDWUGxSfUcjkgPgU15DMQ6xUVFamBEhMJlu8nqowGWtoCLThAmqYlJCRwAAsTdmD0zgTy\/UBsIH2GBItB+C\/IExgWggwHSkQB8V4g\/odF4zmgg1Rh6oGOmESixdiLW6BBlUDBdwQ0\/QCGiC80CnLItBiEr6JYXlxcLAItInFp+AbE7lCHBgDZfyiw\/D8wygwxymho4fENTfFnoLgDksU\/KbEYivtxtURApdVlqKK7QFfqQ4M6HIh\/UcFicD0PSmNYHQBNfMWZmZmCUB8XQFMqqZaAsmQNKFsCPWUFpBciJeYogtkuKyuLB2h3EFDzJhItfgZMoLo42nigqvcgSfU20BGLSLBYCU\/jQx9UJAPVmBBte3l5OT8RWfIrMYbm5OQogqKE1DK+FV8JBsoRxJqFM9HhsVwciL\/jsLyQHi3V+VgsrmGgBwAGrRFyHJNUVVLJATuBli4FYnVKzAEAi4Bewge+mbwAAAAASUVORK5CYII=","width":23}
%---
%[text:image:30b2]
%   data: {"align":"middle","height":23,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAEp0lEQVR42t2a208TQRTG67OJxvv9fiGoD6LGgPiCGo1G\/wljTKDl1pL00RuKIKCIIiKg6ItB8IJ38K4Panz13RcfSBBBQQHRek4ys\/kYpu1uu2132+Sku6eb6X7zmzlz5ux6PEn6lJaWbi0uLu4mGyLrJWvMz8+f4UmnjxA5QhZS7HNZWdnUdNE5hQR9EsLGioqKWuj7kRRbUlJSmS40D4Co4yD+rfAPEdW5rhdKQj4KQQM4J0n0DhjCVW4XuR9oHlV\/J98rSZVsnmuF0nz8oNIsLCxcFQwGp4vf86AjzrhV5D4dTTq+Tr8d0VD95fP5Frpx2L4XAgYlTQpMq+n8DxKm4+0wV6tdJZIo7YWbPwbi26QfqdL5S+H\/7SqqdMPvJE2iOFPOTUEzpM5bpEodUOMWkXs06yb7r6qZEc5dOn\/hKqqQCESiOYkqic4Ff62jRZKg3XCzJ0B8q0akjupzSZU6aZGTl5Q34kZ\/BgKB2ezzer3LOMcNJ5SpSvJIlY7POTWn3QUBpRzEt0QQqYvMzxxNlW7staRJQ3gO0Bw1IdSYz9Qx28Bf57QhuxNu7iSIbzYhclKEpvZ6HElVR5OOl5qkGZEqdcB5p9DMC0OzyYJIXaTuFr4R6rzFTkj3jK1WHDRDarSmdnPAX59qkbkQaU+B\/7IqglM7+g4qVqu5rhzaeeoIqpC2RaVJN52pGfYbdFRlW0iVrr2QcppkFSC+MUxUNSt0AlU6f5JSqpCuGcUtv9+\/JExZ05JQpErf2eC\/mOxIi4v6aRDfEGGdtCJUjeCPhW+Uk5BkCu2xQjNGoQZVWl+30Pk\/4W9I1tzM0RWfeVhFyXysCp0QyaHoPUZtLU\/G3OxWadIfL+Dilt1CMZrTtZuB6qVE7zezdUVnDv0mctlYhKpUHyaFKoR6SzTjEYr\/pVBtTDhNLDZz0m1ydxKrUHWdfiCp+ny+FYmgKUP8sHx8YJamDUK1VDnVtHs5wSFTDeLrLOw34xGqrtf3E0IVgoBRiiwoKJhvlqZNQjEubIKOb7Jr3TQaxeIyF6+sbMFsEKqu2\/ZShQZVmsPJFhqOKrVzxTaaWFTW7SNNCD3IlUI08h2KYXOO63eXpErtrYwnCHWpNDniWqVpsxlUacnLAhDNsa6bWTqaolIQSrFVwei6FxdVGlZ3baY5SNav2KCdVLlYblXkRqB5FnqvOlYKNgWjUJjsTEIZpzbXWIm0d9QCMlfneI\/oFKFKhoZgWs0GIP7zv+qDHu7BeOZVAoSqWZqEM+73+9eaodlpN80ECjXiBwLih87Rnoith4vrgGZlvJEyQUJVqrdNUaULOmRp0U6a8uUMssNo\/BDYBqHDnKlppt21qDTxwQ7vGhywbkbrxBrN1Bsny9DRbFcLxV6vdxad\/3C6UJyryvRrU7OgdfBjPYivcIHIkCYX79BSpZObLqYZkSq\/kicjaqZ04oMcrpS7SGRIzeJIy60JVDk6SZpcbRdDeRr5v2hyU6fbV\/l8VVlXm5lcX0wJsTveYpMVw14PzMOGNBQqE4h+3M8x5hti3UwH64S52y6D0YALA49Z6+P3hCXiDLH2fEsjgd+ZKr9wyRr\/A+UKAPezYlA8AAAAAElFTkSuQmCC","width":23}
%---
%[text:image:9b70]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:7ee0]
%   data: {"align":"baseline","height":23,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAEp0lEQVR42t2a208TQRTG67OJxvv9fiGoD6LGgPiCGo1G\/wljTKDl1pL00RuKIKCIIiKg6ItB8IJ38K4Panz13RcfSBBBQQHRek4ys\/kYpu1uu2132+Sku6eb6X7zmzlz5ux6PEn6lJaWbi0uLu4mGyLrJWvMz8+f4UmnjxA5QhZS7HNZWdnUdNE5hQR9EsLGioqKWuj7kRRbUlJSmS40D4Co4yD+rfAPEdW5rhdKQj4KQQM4J0n0DhjCVW4XuR9oHlV\/J98rSZVsnmuF0nz8oNIsLCxcFQwGp4vf86AjzrhV5D4dTTq+Tr8d0VD95fP5Frpx2L4XAgYlTQpMq+n8DxKm4+0wV6tdJZIo7YWbPwbi26QfqdL5S+H\/7SqqdMPvJE2iOFPOTUEzpM5bpEodUOMWkXs06yb7r6qZEc5dOn\/hKqqQCESiOYkqic4Ff62jRZKg3XCzJ0B8q0akjupzSZU6aZGTl5Q34kZ\/BgKB2ezzer3LOMcNJ5SpSvJIlY7POTWn3QUBpRzEt0QQqYvMzxxNlW7staRJQ3gO0Bw1IdSYz9Qx28Bf57QhuxNu7iSIbzYhclKEpvZ6HElVR5OOl5qkGZEqdcB5p9DMC0OzyYJIXaTuFr4R6rzFTkj3jK1WHDRDarSmdnPAX59qkbkQaU+B\/7IqglM7+g4qVqu5rhzaeeoIqpC2RaVJN52pGfYbdFRlW0iVrr2QcppkFSC+MUxUNSt0AlU6f5JSqpCuGcUtv9+\/JExZ05JQpErf2eC\/mOxIi4v6aRDfEGGdtCJUjeCPhW+Uk5BkCu2xQjNGoQZVWl+30Pk\/4W9I1tzM0RWfeVhFyXysCp0QyaHoPUZtLU\/G3OxWadIfL+Dilt1CMZrTtZuB6qVE7zezdUVnDv0mctlYhKpUHyaFKoR6SzTjEYr\/pVBtTDhNLDZz0m1ydxKrUHWdfiCp+ny+FYmgKUP8sHx8YJamDUK1VDnVtHs5wSFTDeLrLOw34xGqrtf3E0IVgoBRiiwoKJhvlqZNQjEubIKOb7Jr3TQaxeIyF6+sbMFsEKqu2\/ZShQZVmsPJFhqOKrVzxTaaWFTW7SNNCD3IlUI08h2KYXOO63eXpErtrYwnCHWpNDniWqVpsxlUacnLAhDNsa6bWTqaolIQSrFVwei6FxdVGlZ3baY5SNav2KCdVLlYblXkRqB5FnqvOlYKNgWjUJjsTEIZpzbXWIm0d9QCMlfneI\/oFKFKhoZgWs0GIP7zv+qDHu7BeOZVAoSqWZqEM+73+9eaodlpN80ECjXiBwLih87Rnoith4vrgGZlvJEyQUJVqrdNUaULOmRp0U6a8uUMssNo\/BDYBqHDnKlppt21qDTxwQ7vGhywbkbrxBrN1Bsny9DRbFcLxV6vdxad\/3C6UJyryvRrU7OgdfBjPYivcIHIkCYX79BSpZObLqYZkSq\/kicjaqZ04oMcrpS7SGRIzeJIy60JVDk6SZpcbRdDeRr5v2hyU6fbV\/l8VVlXm5lcX0wJsTveYpMVw14PzMOGNBQqE4h+3M8x5hti3UwH64S52y6D0YALA49Z6+P3hCXiDLH2fEsjgd+ZKr9wyRr\/A+UKAPezYlA8AAAAAElFTkSuQmCC","width":23}
%---
%[control:spinner:5a71]
%   data: {"defaultValue":1,"label":"Charge (mC)","max":5,"min":-5,"run":"Section","runOn":"ValueChanged","step":1}
%---
%[control:checkbox:4d56]
%   data: {"defaultValue":true,"label":"Use Logarithmic Scale","run":"Section"}
%---
%[control:dropdown:4816]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","Vector","Contour","Filled Contour","Surface"],"items":["\"??\"","\"Vector\"","\"Contour\"","\"Filled Contour\"","\"Surface\""],"label":"Plot Style","run":"Section"}
%---
%[text:image:87a5]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:72b3]
%   data: {"label":"Show Hint","run":"Section"}
%---
%[control:dropdown:2fc4]
%   data: {"defaultValue":"[]","itemLabels":["??","The field strength goes to zero","The field remains constant","The field strength goes to infinity"],"items":["[]","0","1","2"],"label":"Answer: ","run":"Nothing"}
%---
%[control:button:5bb0]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:49cb]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:0ae7]
%   data: {"label":"Generate Problem Statement","run":"Section"}
%---
%[control:editfield:7e18]
%   data: {"defaultValue":" ","label":"Field Strength","run":"Nothing","valueType":"MATLAB code"}
%---
%[control:button:5958]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:394d]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:spinner:1738]
%   data: {"defaultValue":2,"label":"Number of Charges","max":7,"min":1,"run":"Section","runOn":"ValueChanged","step":1}
%---
%[control:button:4c4f]
%   data: {"label":"Generate Plot","run":"Section"}
%---
%[control:button:260e]
%   data: {"label":"Reset Plot","run":"Section"}
%---
%[text:image:1c39]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:5e95]
%   data: {"label":"Generate Problem Statement","run":"Section"}
%---
%[control:editfield:6088]
%   data: {"defaultValue":"\"\"","label":"Magnitude of the electric field at the origin: ","run":"Nothing","valueType":"String"}
%---
%[control:button:69dd]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:86bc]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB8AAAAcCAYAAACZOmSXAAACP0lEQVR42mNgoCLIy8vzys\/Pf15QUNDNQE9QWFioBLT4CxD\/B2GgA5LoZjnQwi0wi6H4TVlZGS89LA5FsxiGK2hqcW5urijQkidAfA+L5S\/S0tJYaWU3I9CCjUC8GYg\/YfM9MBH60yq4G6GW1OEIdhBeT1VLQUEJNLQDavg2IJ6Kx\/IfwJQvQLGlDQ0NbECDsoEGXoEa\/BUYrDpA+gMey0FBH0+RxdnZ2fJAg26gGVwKdEwBPouheCslFgsDDbiDZuC2kpISbiD9lAjLfwILISFyE9YKNMPugwxDSnDE4GSiLQwNDWUGxSfUcjkgPgU15DMQ6xUVFamBEhMJlu8nqowGWtoCLThAmqYlJCRwAAsTdmD0zgTy\/UBsIH2GBItB+C\/IExgWggwHSkQB8V4g\/odF4zmgg1Rh6oGOmESixdiLW6BBlUDBdwQ0\/QCGiC80CnLItBiEr6JYXlxcLAItInFp+AbE7lCHBgDZfyiw\/D8wygwxymho4fENTfFnoLgDksU\/KbEYivtxtURApdVlqKK7QFfqQ4M6HIh\/UcFicD0PSmNYHQBNfMWZmZmCUB8XQFMqqZaAsmQNKFsCPWUFpBciJeYogtkuKyuLB2h3EFDzJhItfgZMoLo42nigqvcgSfU20BGLSLBYCU\/jQx9UJAPVmBBte3l5OT8RWfIrMYbm5OQogqKE1DK+FV8JBsoRxJqFM9HhsVwciL\/jsLyQHi3V+VgsrmGgBwAGrRFyHJNUVVLJATuBli4FYnVKzAEAi4Bewge+mbwAAAAASUVORK5CYII=","width":23}
%---
%[text:image:041a]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARLoIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xeDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCCM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+CWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTwV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHKQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBtArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyXdjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC04TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8t8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8Dxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCCZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEFJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+EcB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZgf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVatQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:4fcd]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:34d3]
%   data: {"label":"Generate a line","run":"Section"}
%---
%[text:image:9ec4]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:spinner:2fd4]
%   data: {"defaultValue":8,"label":"Number of Segments: ","max":100,"min":1,"run":"Nothing","runOn":"ValueChanging","step":1}
%---
%[control:button:6c2e]
%   data: {"label":"Discretize","run":"Section"}
%---
%[text:image:7f1d]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:777c]
%   data: {"label":"Generate a problem","run":"Section"}
%---
%[control:editfield:42d1]
%   data: {"defaultValue":" ","label":"Answer:","run":"Nothing","valueType":"MATLAB code"}
%---
%[control:button:2eb5]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:3da8]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:47e2]
%   data: {"label":"Plot the line field","run":"Section"}
%---
%[text:image:844d]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:slider:3a71]
%   data: {"defaultValue":8,"label":"Number of Segments","max":200,"min":3,"run":"Section","runOn":"ValueChanged","step":1}
%---
%[text:image:8390]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+SvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+E+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoqKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzvAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0DShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoCB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1eqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btHJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCOriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjtVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/ASgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysrFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNxk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:8314]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:7905]
%   data: {"label":"Generate Problem Statement","run":"Section"}
%---
%[control:editfield:849f]
%   data: {"defaultValue":"\"\"","label":"Answer: ","run":"Nothing","valueType":"String"}
%---
%[control:button:0803]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:201d]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1WW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/onXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGIyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/CTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6Jc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5kG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WNkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tkvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3qRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8xiWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67dwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5IHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OTyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:dropdown:8657]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","Derivative","Integral","Series","Fourier Analysis"],"items":["\"??\"","\"Derivative\"","\"Integral\"","\"Series\"","\"Fourier Analysis\""],"label":"Your answer: ","run":"AllSections"}
%---
%[text:image:310c]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:slider:8fee]
%   data: {"defaultValue":1,"label":"Length","max":5,"min":0,"run":"Section","runOn":"ValueChanged","step":0.1}
%---
%[control:button:930c]
%   data: {"label":"Plot","run":"Section"}
%---
%[text:image:401e]
%   data: {"align":"baseline","height":317,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAdAAAAKmCAYAAAD9zs9BAAAA4WlDQ1BzUkdCAAAYlWNgYDzNAARMDgwMuXklRUHuTgoRkVEKDEggMbm4gAE3YGRg+HYNRDIwXNYNLGHlx6MWG+AsAloIpD8AsUg6mM3IAmInQdgSIHZ5SUEJkK0DYicXFIHYQBcz8BSFBDkD2T5AtkI6EjsJiZ2SWpwMZOcA2fEIv+XPZ2Cw+MLAwDwRIZY0jYFhezsDg8QdhJjKQgYG\/lYGhm2XEWKf\/cH+ZRQ7VJJaUQIS8dN3ZChILEoESzODAjQtjYHh03IGBt5IBgbhCwwMXNEQd4ABazEwoEkMJ0IAAHLYNoSjH0ezAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAZJElEQVR4nO3dW6hld33A8d\/aZybeIo1Oi7GMiGOkFqQqmr401Yi0mWjoGNqUgI43rNIXKS1YKn0Rah\/0oRRBrGi8jNJUaWMwIeMFGi19qWJbkCI4mSqmJYXGaBtqjJm9+jAzmTNnzmXv\/16X\/+XzgQNz5gzn\/Pdam\/\/3\/Nbss04EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADO5MyL6fd7eNd\/SAGjBYu4FJLrmgI+\/ZpJVANCsUgP6owM+\/q1JVgEAhXtPXH4J99i8ywGA\/L00Lo\/ne+ZdDgCU4RtxKZ7fmHktAFCEnZduXzrvcgAgfzsv3frRFQA4wJGIOBOX4nl63uUAQBneH5fi+cPwqlsAWMl+dyHq4\/x0CgCj6eZeQKJ+hX9T6mMDoACl3onokQM+\/s1JVgEAAAAAAAAAAAAAAAAAAAAAAKVzuzsAZvXp45+9rev6z0VE9BEfevN9b3r3qZtPfSL67nh0cW1ERN\/3\/xix+Ms3n37j5+dd7SWl3soPgEp0\/fLZT\/45+mtP3XzqTET31ovxjIjouu7Xolve8enjn71tnlVeSUAByEh3W0T3wl0\/Et3VEcv3Tr2ivQgoAFnpo3+07+PPT973pi6W\/Wsi+gcufqzrupflMoUemnsBI+rD\/\/ECrOWTxz\/5K\/2yf3y5WD689fjWVXFVPLVf9off9uW3fWeyRfSLt1\/8v86TXzp5\/6mbTn0wFvGRJz\/e9b8eEbP\/X6gJFICIiLjj+Knru9h6edcduuFwHL6xO9TdsIjFa7di61fv+M07njfVOna+UOjkl07+1fb3u+ifOdVa9lPzBArACj5y06nnPmX5xHO2or82lvHMrounRx\/PjohzfXSHo1v+aCu2fikifjD3WnNiAgVo2EduOvXcpy\/7X150i6N9dL8Qizi3jO7Hfdf9pOu6x7pl\/y\/RLR7vuu7nP\/Ebn3jZ3OvNiYACNOxp55bXxFYc6aJ7ou\/jcB\/d\/y26\/sfdsu\/7rns0FnG4W\/ZPxDIeWywWxz72mo89f+w17XyR0KePf+aPt7\/f991\/jr2GVQgoQMu24pqIiFjE4S7iGRERL\/\/B3\/11v+i66Jc\/6pd9v+y6ny375U+jj8OLrcVVo6+pW97x6eOfeX\/EhZssRPzBZR\/u+6+MvoYVNPV\/oMfuvqWfew0AWflwHI9lPK3v+iPR9\/\/7igf\/9pPnukPxltMnP\/Spmz51U98tfi66+Nlia3F1v+y3DnWHnhh7SV10V0cX7z1182fee\/4HKrbp4\/TJL528f+w1rKKpgJ49cY8fawHY7qbbboru\/NXIfrF4JCLiX4++4Xc\/9Ysnfq\/rumUf8ePFsu\/76K+KiHPTLKp\/YNebKfTx0GKre\/c0aziYS7gADVv2y+\/30T8S3eInL3\/wrs9\/63m\/81uxjOfEYvF43\/eHF8v+6bGIp\/aLxePRxWPLreXo3VgsFjdH9J\/so380IiL6eCj6OL3Y6l71xnvf+N2xv\/6qmppAAbjc9x783tljzzt29Prv3\/mFc4tDsYzu0CL6B2O5fCIinnFu0f13RMQi4vl9t3hksexHv5J3IZJvu\/CWLQEFaNj7\/u19j5\/92Q1f+cnha+Kfn\/fb71hE\/5RzXfdQt1w+Lba2zi0inh8R57rofxrR\/\/TNX37LmbnXnAuXcAEa9vDR6\/qvPP\/kNYfP\/SQiIpZ91211\/TOji8eWEd\/vIx6J5fKxvu\/\/69wT57K5fJoDEyhAox4+el1\/5MEz3cPxwf7Ig2e6O17w1uu3YvlzfR8RfZzrzj1xVXTdf8Si+1kf\/f+8\/atvf+DAT9oQAQVozMNHr+sjIo48eKa7GNGIiD\/7\/b\/5p7Mn7uk+\/tqPH+u7\/rF3fPUdk9ywoO8WP+wu\/rhKHw9N8TXZn5\/5BNjhYjx3e9\/Pyq\/H\/4ECNGL7tLnb+6xHQAEaIJbDE1CAyu0WT0HdnIACVEwoxyOgAJXaK56iOgwBBaiQeI5PQAEqI5LTEFCAiuwXT2EdloACVEIgpyWgABU4KJ7iOjwBBSicOM7DzeQBCrX9pvAH\/TuBHZ6AAhRIFOfnEi5AYdaJp9COR0ABCiKe+RBQgEIIYl4EFKAA68ZTbMcnoACZE8M8CShAxlLiKbjTEFCATAlh3gQUIEOp8RTd6QgoQGbEswwCCpARESyHgAJkYpN4Cu\/0BBQgAwJYHjeTB5jRqr9R5aDPIb7TE1CAmQhf2VzCBZjBUPEU4fkIKMDExLMOAgowIdGrh4ACTGTIeArx\/AQUYAKCVx8BBRjZ0PEU4zwIKMCIxK5eAgowkjHiKcj5EFCAEYhn\/QQUYGBC1wYBBRjQWPEU5fwIKMBARK4tbiYPsKEhfqPKQZ9fmPMjoAAbELd2uYQLkGiKeAp0vgQUIIGwIaAAa5oqniKdNwEFWIN4cpGAAqxI1NhOQAFWMGU8hboMAgpwAEFjN8X\/HOirjn\/z73f7+6+ffuWuH\/v66Ve+ZvxVAbWYOp5iXQ4TKMAexIz9CCjALuaIp2CXRUABdhBPVlH8\/4ECDGXsm8JTFwEFiHknQNNnmVzCBZonYKQQUKBpc8dz7q9POgEFmiVebEJAgSblEM8c1kA6AQWak0O4clgDmxFQoCnCxVAEFGhGLvHMZR1sRkCBJogWQxNQoHo5xTOntbAZAQWqJliMRUCBauUWz9zWw2YEFKhSbrHKbT1szs3kgar4jSpMRUCBauQ65eW6LjbjEi5QBZFiagIKFC\/neOa8NjYjoEDRBIq5CChQrNzjmfv62IyAAkXKPU65r4\/NCShQHHEiBwIKFKWEeJawRjYnoEAxhImcCChQhFLiWco62ZyAAtkTJXIkoEDWSopnSWtlc+6FC2TJTeHJnYAC2SlxkitxzWzGJVwgKyWGqMQ1szkBBbIhRJREQIEslBrPUtfN5gQUmJ0IUSIBBWZVcjxLXjubE1BgNgJEyQQUmEXp8Sx9\/WxOQIHJlR6f0tfPMAQUmJT4UAsBBSZTQzxreAwMQ0CBSQgPtRFQYHS1xLOWx8Ew3EweGI3fqELNBBQYRW3TWm2Ph825hAsMrrbY1PZ4GIaAAoMSG1ohoMBgaoxnjY+JYQgoMAihoTUCCmys1njW+rgYhoACGxEZWiWgQLKa41nzY2MYAgokqTkwNT82hiOgwNoEBgQUWFPt8az98TEcAQVWJi5wiYACK2khni08RobjZvLAvvxGFdidgAJ7amkia+mxMgyXcIFdCQrsT0CBK7QWz9YeL8MQUOAyrcWktcfLcAQUeJKYwOoEFIiINuPZ4mNmOAIKCAkkEFBoXKvxbPVxMxwBhYaJCKQTUGhUy\/Fs+bEzHAGFBrUckJYfO8MSUGiMgMAw3AsXGuGm8L55YFgCCg0QDhieS7hQOfE8z3FgaAIKFRMNGI+AQqXE8xLHgjEIKFRIMC5xLBiLgEJlBAOmIaBQEfG8nOPBmAQUKiEWMC0BhQqI55UcE8YmoFA4oYB5CCgUTDx357gwBQGFQonE7hwXpiKgUCCRgPm5mTwUxG9U2Z9vLJiSgEIhxAHy4hIuFEA8D+YYMTUBhcwJA+RJQCFj4rkax4k5CChkShQgbwIKGRLP1TlWzEVAITOCsDrHijkJKGREEKAcAgqZEM\/1OF7MTUAhA2IA5RFQmJl4rs8xG8fZE\/d0x+6+pZ97HaUQUJiREEC5BBRmIp5pHDdy4WbyMDG\/USWdeJITAYUJCQDUwyVcmIh4bsbxIzcCChOw+UN9BBRGJp6bcwzJkYDCiGz8UC8BhZGI5zAcR3IloDACm\/4wHEdyJqAwMJs+tEFAYUDiORzHktwJKAzEhg9tEVAYgHgOy\/GkBAIKG7LZQ5vcCxcSuSn8OHxDQikEFBLY5MfhuFISl3BhTTZ5IEJAYS3iOR7HltIIKKzIBg9sJ6CwAvEcl+NLiQQUDmBzB3YjoLAP8RyfY0ypBBT2YGMfn2NMyQQUdmFjBw4ioLCDeE7DcaZ0Agrb2NSBVQkoXCCe03GsqYGAQtjQgfW5mTxN8xtVpuebFWohoDTLRg5swiVcmiSe83DcqYmA0hyb+Dwcd2ojoDTFJg4MRUBphnjOx7GnRgJKE2zgwNAElOqJ57wcf2oloFTN5g2MRUCplnjOzzmgZgJKlWzc83MOqJ2AUh0bNzAFAaUq4pkH54EWuBcuVXBTeGBqAkrxTDt5cT5ohUu4FM1mDcxFQCmWeObHOaElAkqRbNT5cU5ojYBSHBs1kAMBpSjimSfnhRYJKMWwSQM5EVCKIJ75cm5olYCSPRs0kCMBJWvimTfnh5YJKNmyOefN+aF1AkqWbM5A7gSU7Ihn\/pwjcDN5MuI3qgAlEVCyYKIph3MF57mEy+xsyECJBJRZiWdZnC+4RECZjc0YKJmAMgvxLI9zBpcTUCZnIy6PcwZXElAmZSMGaiGgTEY8y+S8we4ElEnYhIHaCCijE89yOXewNwFlVDZgoFYCymjEs2zOH+xPQBmFzbdszh8czM3kGZTfqAK0QkAZjKmlDs4jrMYlXAZh0wVaI6BsTDzr4VzC6gSUjdhwgVYJKMnEsy7OJ6xHQElis62L8wnrE1DWZrMFEFDWJJ71cU4hjYCyMhstwCUCykrEs07OK6QTUA5kkwW4koCyL\/Gsl3MLm3EvXHblpvB1E0\/YnIByBZsrwMFcwuUy4lk\/5xiGIaA8ycYKsDoBJSLEsxXOMwxHQLGpAiQQ0MaJZzucaxiWgDbMhtoO5xqGJ6CNsqECbEZAGySebXG+YRwC2hibKcAwBLQh4tke5xzGI6CNsJECDEtAGyCebXLeYVxuJl8xv1EFYDwCWinTR9ucfxifS7gVsnm2zfmHaQhoZWyeANMQ0IqIJ54DMB0BrYSNE2BaAloB8STC8wCmJqCFs2kCzENACyaeXOS5ANMT0ELZMLnIcwHmIaAFsmECzE9ACyOebOf5APMR0ILYLAHy4V64BXBTeHbjGyqYl4BmziYJkCeXcDMmnuzFcwPmJ6CZskGyF88NyIOAZsgGCZA\/Ac2MeLIfzw\/Ih4BmxOYIUA4BzYR4chDPEciLgGbAxghQHgGdmXiyCs8TyI+AzsimyCo8TyBPAjoTmyJA2QR0BuLJqjxXIF8COjEbIkAd3Ex+In6jCuvyzRbkTUAnYCMEqI9LuCMTT1J43kD+BHRENkGAegnoSMSTVJ47UAYBHYENkFSeO1AOAR2YDRCgDQI6IPFkE54\/UBYBHYjND6AtAjoA8WRTnkNQHgHdkI0PoE0CugHxZAieR1AmAU1k02MInkdQLgFNYNMDwM3k1+A3qjAk34hB2QR0RTY7ALZzCXcF4snQPKegfAJ6ABsdALsR0H2IJ2PwvII6COgebHKMwfMK6iGgu7DJAXAQAd1BPBmL5xbUxY+xbGODAxjHC+5+\/W1ddJ+LiIg+Hjr7hnueO\/OSNmYCvUA8GZPnF61bRDzryXe6uHbGpQxGQMPmBsD6mg+oeDI2zzGoU9MBtbExNs8xqFeTLyJyU3iA+b3g7tff0fXdzdHFtX30j0Yf\/7Do4wMP3Hrv\/XOvbRXNTaAXJwLxZGymT9jbC+6+5UwX3dsuvqCoi+7qrutuXi7ii8e++PoXzb2+VTQV0Lu+ffuNNjSA+XURL9z977ur+2X8ydTrSdFMQO\/69u033vqSO++fex20wfQJ++ujfzSif\/\/ZE\/d0XfTvOv\/+eV10L59zbatqIqDiCZCXRcQfnT1x759GRDxw4t6PdtHdt+3DL5tpWWupPqDiydRMn3CwB07c+9Ht72+fQEtR9atw94rnsbtv6WdYDo24PiKOxYs9xyjK2RP3+KZvTdUG9OGj18Vek6cnCmMxfUI7qr2Ee+TBM3MvgcaIJ7Sl2oACwJgEFAZg+oT2CCgAJBBQ2JDpEw62jHjk4p93+5GVLuI7cekfPDTRsjZS7atwAcjHv5+49\/MRsec3mmdP3PuBiPjAdCvanAkUNmD6hHYJKCQST2ibgAJAAgGFBKZPQEABIIGAwppMn0CEgAJAEgGFNZg+gYsEFFYknsB2AgoACQQUVmD6BHYSUABIIKBwANMnsBsBBYAEAgr7MH0CexFQ2IN4AvsRUABIIKCwC9MncBABBYAEAgo7mD6BVQgoACQQUNjG9AmsSkDhAvEE1iGgAJBAQCFMn8D6BBQAEggozTN9AikEFAASCChNM30CqQQUABIIKM0yfQKbEFCaJJ7ApgQUABIIKM0xfQJDEFAASCCgNMX0CQxFQAEgwaEhPsmrj3\/zhj76+7rorj7\/N\/0ffu309X8xxOeGoZg+gSENM4EuuxddimdE9PHiQT4vDEQ8gaG5hAsACQSU6pk+gTEIKAAkEFCqZvoExiKgAJBAQKmW6RMYk4BSJfEExiagAJBAQKmO6ROYgoACQAIBpSqmT2AqAgoACQb5bSxX6Lp3vvr4N9955d\/HrV+775VfGOVr0jzTJzClaSfQc92zJv16NEM8gakNEtCvffkVn+ijf\/Tgr9Z\/d4ivBwBzG+wS7tdPX\/\/MoT4XrMP0CczBi4gAIIGAUjTTJzAXAQWABAJKsUyfwJwElCKJJzA3AQWABAJKcUyfQA4EFAASCChFMX0CuRBQAEggoBTD9AnkREABIIGAUgTTJ5AbASV74gnkSEABIIGAkjXTJ5ArAQWABAJKtkyfQM4EFAASCChZMn0CuRNQsiOeQAkEFAASCChZMX0CpRBQAEggoGTD9AmUREABIIGAkgXTJ1AaAWV24gmUSEABIIGAMivTJ1AqAQWABALKbEyfQMkEFAASCCizMH0CpRNQJieeQA0EFAASCCiTMn0CtRBQAEggoEzG9AnUREABIIGAMgnTJ1AbAQWABALK6EyfQI0ElFGJJ1ArAQWABALKaEyfQM0EFAASCCijMH0CtRNQAEggoAzO9Am0QEAZlHgCrRBQAEggoAzG9Am0REABIIGAMgjTJ9AaAQWABALKxkyfQIsElI2IJ9AqAQWABAJKMtMn0DIBBYAEAkoS0yfQOgEFgAQCytpMnwACyprEE+A8AQWABALKykyfAJcIKAAkEFBWYvoEuJyAAkACAeVApk+AKwkoACQQUPZl+oS2nD1xT3fs7lv6uddRAgFlT+IJsDcBBYAEAsquTJ8A+xNQAEggoFzB9AlwMAEFgAQCymVMnwCrEVCeJJ4AqxNQAEggoESE6RNgXQIKAAkEFNMnQAIBBYAEAto40ydAGgFtmHgCpBNQAEggoI0yfQJsRkABIIGANsj0CbA5AQWABALaGNMnwDAEtCHiCTAcAQWABALaCNMnwLAEFAASCGgDTJ8AwxNQAEggoJUzfQKMQ0ArJp4A4xFQAEggoJUyfQKMS0ABIIGAVsj0CTA+AQWABAJaGdMnwDQEFAASCGhFTJ8A0xHQSognwLQEFAASCGgFTJ8A0xNQAEggoIUzfQLMQ0ABIIGAFsz0CTAfAS2UeALMS0ABIIGAFsj0CTA\/AQWABAJaGNMnQB4EFAASCGhBTJ8A+RDQQognQF4EFAASCGgBTJ8A+RFQAEggoJkzfQLkSUABIIGAZsz0CZAvAc2UeALkTUABIIGAZsj0CZA\/AQWABAKaGdMnQBkEFAASCGhGTJ8A5RBQAEggoJkwfQKURUAzIJ4A5RFQAEggoDMzfQKUSUABIIGAzsj0CVAuAQWABAI6E9MnQNkEdAbiCVA+AQWABAI6MdMnQB0EFAASCOiETJ8A9RBQAEggoBMxfQLURUAnIJ4A9RFQAEggoCMzfQLUSUABIIGAjsj0CVAvAQWABAI6EtMnQN0EdATiCVA\/AQWABAI6MNMnQBsEFAASCOiATJ8A7RBQAEggoAMxfQK0RUAHIJ4A7RFQAEggoBsyfQK0SUABIIGAbsD0CdAuAQWABAKayPQJ0DYBBYAEAprA9AmAgK5JPAGIEFAASCKgazB9AnCRgAJAAgFdkekTgO0EFAASCOgKTJ8A7CSgBxBPAHYjoACQQED3YfoEYC8CCgAJBHQPpk8A9iOgAJBAQHdh+gTgIAK6g3gCsAoBBYAEArqN6ROAVQkoACQQ0AtMnwCsQ0ABIIGAhukTgPU1H1DxBCBF8wEFgBRNB9T0CUCqpgMKAKmaDajpE4BNNBtQANhEkwE1fQKwqSYDCgCbai6gpk8AhtBUQO\/69u03iicAQ2gqoAAwlGYCete3b7\/x1pfcef\/c6wCgDs0EFACG1ERATZ8ADK2JgALA0KoPqOkTgDFUHVDxBGAsVQcUAMZSbUAfPnpdmD4BGEu1AQWAMVUZ0Au37Jt7GQBUrMqAApDu7Il73DO8RQ8fva6\/8Mfemzdv3rwd+HaQl+7496\/b8fH3bPvYh1f4fADQjDNxKZLb\/3\/sWET8cNvHbph+aQCQrxvi8in09gt\/\/+EwfQLAvk7H5VPozku7x+ZbGgDka+cUuv3SrekTAPZxZ1z5IqQfRsSRORcFALl7XVwZ0G\/MuiIAKMD2V+Nuf\/PqWwDYw+1x+YuI9vrRFgDggiNx+YuGbo\/Lg7r9R1sAgAu2321o+7RpCgWAPey829D2SXPni4reM\/nqACBT74r9X3G78wYLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJTj\/wHy4a3GCMs6fAAAAABJRU5ErkJggg==","width":216}
%---
%[text:image:97e3]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7V\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/FX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6Lxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dMmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A300HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6W6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4lBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9QJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2LKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlGYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy31Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyfhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXxxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:4d6e]
%   data: {"label":"Plot","run":"Section"}
%---
%[text:image:31ec]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+SvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+E+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoqKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzvAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0DShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoCB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1eqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btHJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCOriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjtVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/ASgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysrFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNxk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElFTkSuQmCC","width":22}
%---
%[control:slider:2c89]
%   data: {"defaultValue":1,"label":"Line Length","max":20,"min":0.001,"run":"Section","runOn":"ValueChanging","step":0.1}
%---
