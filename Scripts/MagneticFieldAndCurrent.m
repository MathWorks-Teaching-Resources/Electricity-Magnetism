%[text] %[text:anchor:TMP_0f9c] # Magnetic Fields and Currents
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%[text] Magnetic fields and electric currents show up everywhere from how a compass points north to how an MRI scanner works. In this script, we’ll play around with visualizing and computing the magnetic fields
%[text]{"align":"center"} 
%[text]{"align":"center"} ![](text:image:9173)
%%
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%%
%[text] %[text:anchor:H_BF646A47] This live script is intended to be used with the code hidden. On the **View** tab of the MATLAB toolstrip, in the **View** section, select **Hide Code**.  Alternately, select **Hide Code** using the icon ![live script code hidden icon](text:image:002c) at the top right of the Live Editor pane.
%[text] ![Lightbulb mark](text:image:9460) Although the code is hidden, some interactivity requires familiarity with MATLAB. If you need more instruction, consider taking [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted), a free 2 hour online tutorial that teaches the essentials of MATLAB.
%[text] %[text:anchor:H_8F8A032D] ![Warning symbol](text:image:99f7)   For an optimal experience, follow the instructions and steps in the given sequence. Proceed to a new section only after completing the preceding one. Some sections depend on variables created in prior sections and will generate errors if run out of order.
%[text] The ![Try this icon](text:image:1f0d)  and  ![Exercise icon](text:image:8e0b) icons refer to two different types of interactive activities that you will find in this script. The ![Try this icon](text:image:4936)  usually indicates an interaction where you will explore the visualization of some concept introduced in this script. The ![Exercise icon](text:image:15b7) interactions are designed to challenge your understanding of those concepts and may be used for grading and completion checks by your professor.
%%
%[text] %[text:anchor:TMP_3419] ## Magnetic Force on a Charged Particle
%[text] When an electric current flows through a wire, it creates a magnetic field around it. That magnetic field can push on other moving charges, whether they’re inside another wire or just drifting through space. This idea that a moving charged particle feels a force in a magnetic field—is one of the core building blocks of electromagnetism.
%[text] A charged particle with charge $q$ moving with velocity $\\vec{v}$ in a magnetic field $\\vec{B}$ experiences a **magnetic (Lorentz) force** given by:
%[text]{"align":"center"} $\\vec{F} = q\\, (\\vec{v} \\times \\vec{B}) \\qquad (1)$
%[text] Where:
%[text] - $\\vec{F}$ is the **magnetic force vector** (in **newtons**),
%[text] - $q$ is the **electric charge** of the particle (in **coulombs**),
%[text] - $\\vec{v}$ is the **velocity vector** of the particle (in **meters per second**),
%[text] - $\\vec{B}$ is the **magnetic flux** density (in **teslas**),
%[text] - $\\times$ denotes the vector cross product. \
%[text] %[text:anchor:M_6be5] ![](text:image:7ceb) **Try.** Use the control below to simulate the trajectory of a charge particle inside a magnetic field. You can modify the initial velocity direction and magnetic field direction to see how it affects the trajectory.
% Simulation Parameters
v0 = [1; 0.5; 0.3]; % Initial velocity (m/s) %[control:editfield:7d9c]{"position":[6,19]}
if norm(v0)~=0
    v0 = v0/norm(v0)*1e6;
end

% Magnetic field (Tesla)
B = [0; 0; 1];          % Uniform field in z-direction %[control:editfield:975f]{"position":[5,14]}
  %[control:button:769f]{"position":[1,2]}

SimulateChargedParticleInMagneticField(B=B,v0=v0)

function SimulateChargedParticleInMagneticField(opts)
arguments
    opts.v0 (3,1) double                    % Initial velocity (m/s)
    opts.B (3,1) double                     % Magnetic field vector (T)
    opts.q (1,1) double = 1.602e-19        % Charge (C) - electron charge
    opts.m (1,1) double = 1.673e-27        % Mass (kg) - proton mass
    opts.r0 (3,1) double = [0;0;0]         % Initial position (m)
    opts.ShowEnergy (1,1) logical = false  % Display kinetic energy plot
end
    
    % Extract parameters
    InitialVelocity = opts.v0;
    MagneticField = opts.B;
    Charge = opts.q;
    Mass = opts.m;
    InitialPosition = opts.r0; 
    ShowEnergy = opts.ShowEnergy;

    % Time parameters
    FinalTime = 1e-7;
    NumSteps = 100;
    TimeVector = linspace(0, FinalTime, NumSteps);

    % Solve Lorentz force equation: F = q(v × B)
    InitialState = [InitialPosition; InitialVelocity];
    LorentzForce = @(t,y) Charge * cross(y(4:end), MagneticField);
    StateDerivative = @(t,y) [y(4); y(5); y(6); LorentzForce(t,y)/Mass];
    [TimeVector, State] = ode45(StateDerivative, TimeVector, InitialState);
    
    Position = State(:,1:3)';
    Velocity = State(:,4:6)';
    
    % Compute normalized kinetic energy
    if sum(Velocity(:,1)) ~= 0
        KineticEnergy = sum(Velocity.^2) / norm(Velocity(:,1).^2);
    else
        KineticEnergy = zeros(1, NumSteps);
    end
    
    % Setup figure
    figure(Position=[0 0 840 500])
    if ShowEnergy
        Layout = tiledlayout(1, 2);
        nexttile
    end

    hold on
    grid on
    box on
    view(-45, 30)
    xlabel("X Position (m)");
    ylabel("Y Position (m)");
    zlabel("Z Position (m)");
    
    % Calculate axis limits with margin
    XRange = [min(Position(1,:)) max(Position(1,:))];
    YRange = [min(Position(2,:)) max(Position(2,:))];
    ZRange = [min(Position(3,:)) max(Position(3,:))];
    MaxRange = max([diff(XRange) diff(YRange) diff(ZRange) 1e-6]);
    Margin = 0.1;
    
    XLimits = XRange + [-1 1] * Margin * MaxRange;
    YLimits = YRange + [-1 1] * Margin * MaxRange;
    ZLimits = ZRange + [-1 1] * Margin * MaxRange;
    xlim(XLimits);
    ylim(YLimits);
    zlim(ZLimits);

    % Draw magnetic field vectors
    [GridX, GridY] = meshgrid(linspace(XLimits(1)+0.05*MaxRange, XLimits(2)-0.05*MaxRange, 5), ...
                              linspace(YLimits(1)+0.05*MaxRange, YLimits(2)-0.05*MaxRange, 5));
    GridZ = zeros(size(GridX)) + mean(ZLimits);

    FieldScale = diff(ZLimits) * 0.1;
    FieldU = ones(size(GridX)) * MagneticField(1) * FieldScale;
    FieldV = ones(size(GridX)) * MagneticField(2) * FieldScale;
    FieldW = ones(size(GridX)) * MagneticField(3) * FieldScale;
    FieldQuiver = quiver3(GridX, GridY, GridZ, FieldU, FieldV, FieldW, ...
                          "off", "filled", SeriesIndex=1, LineWidth=2);

    % Initialize animated elements
    TrajectoryLine = plot3(Position(1,1), Position(2,1), Position(3,1), ...
                           LineStyle="-", LineWidth=2, SeriesIndex=2);
    ParticleMarker = plot3(Position(1,1), Position(2,1), Position(3,1), ...
                           "ro", MarkerSize=12, MarkerFaceColor="r");

    % Add velocity vector
    VelocityScale = diff(XRange) * 0.1 / norm(InitialVelocity);
    VelocityArrow = quiver3(Position(1,1), Position(2,1), Position(3,1), ...
                            InitialVelocity(1)*VelocityScale, ...
                            InitialVelocity(2)*VelocityScale, ...
                            InitialVelocity(3)*VelocityScale, ...
                            "off", "filled", SeriesIndex=5, LineWidth=2, MaxHeadSize=100);
    
    % Add legend and title
    if ShowEnergy
        title(Layout, "Charged Particle Motion in Magnetic Field");
        legend([FieldQuiver, TrajectoryLine, ParticleMarker], ...
               "Magnetic Field", "Trajectory", "Particle", Location="southoutside");
    else
        title("Charged Particle Motion in Magnetic Field");
        legend([FieldQuiver, TrajectoryLine, ParticleMarker], ...
               "Magnetic Field", "Trajectory", "Particle", Location="bestoutside");
    end
    
    hold off
    
    % Setup energy plot if requested
    if ShowEnergy
        nexttile
        EnergyPlot = plot(TimeVector(1), KineticEnergy(1));
        xlim([min(TimeVector), max(TimeVector)])
        ylim([0 2])
        xlabel("Time (s)")
        ylabel("Kinetic Energy (normalized)")
        yticks(0)
    end

    % Animation loop
    for i = 2:NumSteps
        set(TrajectoryLine, "XData", Position(1,1:i), ...
                            "YData", Position(2,1:i), ...
                            "ZData", Position(3,1:i));

        set(ParticleMarker, "XData", Position(1,i), ...
                            "YData", Position(2,i), ...
                            "ZData", Position(3,i));

        set(VelocityArrow, "XData", Position(1,i), ...
                           "YData", Position(2,i), ...
                           "ZData", Position(3,i), ...
                           "UData", Velocity(1,i)*VelocityScale, ...
                           "VData", Velocity(2,i)*VelocityScale, ...
                           "WData", Velocity(3,i)*VelocityScale);
        
        if ShowEnergy
            set(EnergyPlot, "XData", TimeVector(1:i), ...
                            "YData", KineticEnergy(1:i));
        end
        
        drawnow;
    end
end
%%
%[text] ![](text:image:2c0a) **Exercise 1.** Using the [visualization above](internal:M_6be5), answer the following question.
%%
%[text] a. What happens if a particle's velocity is null (zero) in a magnetic field? 
CheckExercise1a("??") %[control:dropdown:74da]{"position":[17,21]}
function CheckExercise1a(Answer)
    switch (Answer)
        case "A"
            warning("Incorrect. The Lorentz force depends on the velocity of the particle. If the velocity is zero, the force is also zero.")
        case "B"
            disp("Correct! The magnetic component of the Lorentz force is given by ( \vec{F} = q\vec{v} \times \vec{B} ). If ( \vec{v} = 0 ), then ( \vec{F} = 0 ).")
        case "C"
            warning("Incorrect. The particle cannot move in a circular path if it is not moving at all.")
        case "D"
            warning("Incorrect. With zero velocity, there is no magnetic force to cause any acceleration.")
        otherwise
            warning("Please select a valid answer.")
    end
end
%%
%[text] b. What happens if a particle's velocity is parallel to the magnetic field?
CheckExercise1b("??") %[control:dropdown:33c7]{"position":[17,21]}
function CheckExercise1b(Answer)
    switch (Answer)
        case "A"
            warning("Incorrect. The force is maximum when the velocity is perpendicular to the magnetic field, not parallel.");
        case "B"
            disp("Correct! The cross product ( \vec{v} \times \vec{B} ) is zero when ( \vec{v} ) is parallel to ( \vec{B} ), so the force is zero.");
        case "C"
            warning("Incorrect. A helical path occurs when the velocity has both parallel and perpendicular components relative to the magnetic field.");
        case "D"
            warning("Incorrect. The magnetic force does not reverse the direction of a particle moving parallel to the field; it simply does not act on it.");
        otherwise
            warning("Please select a valid answer.");
    end
end
%%
%[text] c. What happens if a particle's velocity is perpendicular to the magnetic field?
CheckExercise1c("??") %[control:dropdown:4fbb]{"position":[17,21]}
function CheckExercise1c(Answer)
    switch (Answer)
        case "A"
            warning("Incorrect. The magnetic force acts as a centripetal force, causing the particle to move in a circular path.")
        case "B"
            warning("Incorrect. The force is actually at its maximum when the velocity is perpendicular to the magnetic field.")
        case "C"
            disp("Correct! The magnetic force acts perpendicular to the velocity, resulting in uniform circular motion.")
        case "D"
            warning("Incorrect. The magnetic force does not perform work and cannot stop the particle; it only changes the direction of motion.")
        otherwise
            warning("Please select a valid answer.")
    end
end
%%
%[text] %[text:anchor:TMP_0031] ## **Work Done by the Magnetic Force**
%[text] In the previous section, we studied how the trajectory of a charged particle is changed while experiencing the force from a magnetic field. We should now look at how much energy is transmitted, or in other words how much work is done by the magnetic force on the charged particle.
%[text] We know that the magnetic force is given by:
%[text]{"align":"center"} $\\vec{F} = q\\, (\\vec{v} \\times \\vec{B}) \\qquad (1)$
%[text] If work is defined as:
%[text]{"align":"center"} $W = \\int \\vec{F}\\cdot d\\vec{r} = \\int \\vec{F}\\cdot\\vec{v}dt\\qquad (2)$
%[text]{"align":"center"} 
%[text] ![](text:image:4597) **Exercise 2.** After replacing $\\vec{F}$ in $(2)$ by its expression from $(1)$, what can you tell about the work $W$ done by the magnetic force on the particle?
%[text] 1. $W = \\int q (\\vec{v} \\times \\vec{B}) \\cdot \\vec{v} dt$
%[text] 2. $W = 0$
%[text] 3. $W = \\int q (\\vec{B} \\times \\vec{v}) \\cdot \\vec{v} dt$
%[text] 4. $W = \\int q (\\vec{v} \\times \\vec{v}) \\cdot \\vec{B} dt$ \
CheckExercise2("??") %[control:dropdown:96d4]{"position":[16,20]}
function CheckExercise2(Answer)
    switch (Answer)
        case "1"
            warning("Your calculations are correct so far, but you can go a step further using the following identity: (a×b)·a = 0.")
            displayFormula()
        case "2"
            disp("Correct! Magnetic forces do no work!")
        case "3"
            warning("Your calculations are correct so far, but you can rearrange the dot product to get closer to the answer: (a×b)·c = (c×a)·b.")
        case "4"
            warning("Your calculations are correct so far, but you can go a step further using the identity: a×a = 0.")
        otherwise
            warning("Please select a valid answer.")
    end
end
%%
%[text] Let's take a step back and look back at our particle simulation from earlier. The magnetic force was clearly having an effect on the trajectory of the particle, so how much work was provided to the particle?
%[text] ![](text:image:52ac) **Demonstration.** Re-run the simulation, only this time we will also look at the effect on the kinetic energy of the particle, if work is applied to the particle, the kinetic energy should go up.
% Simulation Parameters
v0 = [1; 0.5; 0.3]; % Initial velocity (m/s) %[control:editfield:8819]{"position":[6,19]}
if norm(v0)~=0
    v0 = v0/norm(v0)*1e6;
end

% Magnetic field (Tesla)
B = [0; 0; 1];          % Uniform field in z-direction %[control:editfield:7b8e]{"position":[5,14]}
  %[control:button:09a6]{"position":[1,2]}

SimulateChargedParticleInMagneticField(B=B,v0=v0,ShowEnergy=true)
%%
%[text] %[text:anchor:TMP_0d02] ## Magnetic Fields Due to Electric Current 
%[text] In the previous sections, we have focused on the magnetic force experienced by a charged particle in a magnetic field, but we have not yet explored what a magnetic field actually is or where it comes from. One of the fundamental sources of a magnetic field is an **electric current**, which is the flow of electric charge through a conductor. 
%[text] An **electric current** is the flow of electric charge through a conductor, such as a wire. In most cases, this flow is due to the movement of electrons. The current is a measure of how much charge passes through a given point in the conductor per unit of time, and it is usually denoted by the symbol $i$ or $I$. Its SI unit is the **ampere (A)**, where 1 A = 1 coulomb of charge passing per second.
%[text] ![](text:image:1909) **Exercise 3.** Use the button below to generate a problem statement and solve the problem. You can use the edit field below to enter your answer or even type your mathematical formula (use $q$ for charge and $tau$ for the time scale).
%%
Prob = GenerateProblemStatement3;  %[control:button:63e6]{"position":[34,35]}

function y = GenerateProblemStatement3()
Charge = 1:10;
Charge = Charge(randi(10));
TimeScale = randi([1 5]);

displayFormula(['"A copper wire carries a flow of electrons such that "' ...
    "q == Charge" ...
    '" coulombs of charge pass through a cross‑section of the wire every "' ...
    "tau == TimeScale" ...
    '" seconds."' ])

displayFormula('"What is the current in the wire?"')

y.ID = "Ex3";
y.Charge = Charge;
y.TimeScale = TimeScale;
end
%%
  %[control:button:150d]{"position":[1,2]}
displayFormula('"Hint: Check the dimensions: q has units of coulombs, and \\tau has units of seconds. How do these combine to produce amperes?"')
%%
CheckExercise3(Prob," " ) %[control:editfield:126c]{"position":[22,23]} %[control:button:1ded]{"position":[24,25]}

function CheckExercise3(Prob,Answer)
% Check that it is the right exercise
if ~contains(Prob.ID,"Ex3")
    warning("Click generate problem above to generate a problem statement.")
    return
end

% Check Answer
Answer = replace(Answer,"q",string(Prob.Charge));
Answer = replace(Answer,"tau",string(Prob.TimeScale));
Answer = double(str2sym(Answer));
RightAnswer = Prob.Charge/Prob.TimeScale;
if IsClose(Answer,1/RightAnswer)
    warning("You are close, check the unit of your calculation, they should be in Coulomb per second (C/s)")
    return
end
if IsClose(Answer,RightAnswer)
    disp("Good job! You computed the current correctly.")
else
    warning("Incorrect. Please try again (consider using the hint above).")
end
end
%%
%[text] %[text:anchor:TMP_02ee] ### The Biot-Savart Law
%[text] Now that we know magnetic fields are produced by moving charges, we need a way to calculate the magnetic field created by a given current. The **Biot–Savart Law** provides this connection between electric currents and the magnetic fields they generate:
%[text]{"align":"center"} $\\vec{B}(\\vec{r}) = \\frac{\\mu\_0}{4\\pi} \\int{ \\frac{I\\vec{d\\mathcal{l}} \\times \\hat{r}}{r^2} } \\qquad (3)\n$
%[text] **Where:**
%[text] - $\\vec{B}(\\vec{r})$ is the **magnetic field vector** at the position $\\vec{r}$ (in **teslas**, T),
%[text] - $\\mu\_0$ is the **permeability of free space**, equal to $4\\pi \\times 10^{-7}\\$ (in **teslas meter per amperes,** $\\text{T\\cdot m/A}$),
%[text] - $I$ is the **electric current** flowing through the conductor (in **amperes**, A),
%[text] - $d\\vec{\\mathcal{l}}$ is an **infinitesimal vector element** of the current-carrying wire, pointing in the direction of current flow (in **meters**, m),
%[text] - $\\hat{r}$ is a **unit vector** pointing from the current element toward the point where $\\vec{B}$ is being evaluated (dimensionless),
%[text] - $r$ is the **distance** between the current element and the observation point (in **meters**, m),
%[text] - $\\times$ denotes the **vector cross product**, indicating that the direction of $\\vec{B}$ is perpendicular to both $d\\vec{\\mathcal{l}}$ and $\\hat{r}$. \
%%
%[text] %[text:anchor:TMP_9132] ### Example: Magnetic Field of a Current Loop
%[text] In this example, we will work step by step to compute the magnetic field generated by a current loop at one point in space.
%[text] ![Try this icon](text:image:071e) **Try.** Click the button to generate a circular current loop and visualize its magnetic field.
  %[control:button:6611]{"position":[1,2]}
CurrentLoop = GenerateCurrentLoop;
CurrentLoop = PlotCurrentLoop(CurrentLoop);

function ProblemData = GenerateCurrentLoop(varargin)

% Initialize problem data structure
if nargin == 0
    ProblemData.ID = "CurrentLoop";
    ProblemData.Current = randi(5);
    ProblemData.CurrentSegment = 1;
    ProblemData.NumSegment = 5;
    ProblemData.QueryPoint = [0 0 0];
    ProblemData.MagneticField = [0 0 0];
    ProblemData.AxesHandle = [];
    return
else
    ProblemData = varargin{1};
    for ii = 2:2:size(varargin,2)
        ProblemData.(varargin{ii}) = varargin{ii+1};
    end
end

end

function ProblemData = PlotCurrentLoop(ProblemData,opts)
arguments
    ProblemData (1,1) struct
    opts.HighlightSegment (1,1) logical = false;
    opts.ShowDistanceVec (1,1) logical = false;
    opts.ShowQueryPoint (1,1) logical = false;
    opts.ShowTotalField (1,1) logical = false
    opts.ShowdB (1,1) logical = false
end
    
    % Check that we have the right problem data
    if ProblemData.ID ~= "CurrentLoop"
        disp("Generate a current loop problem before to run this.")
        return
    end

    % Check if figure needs to be created
    if isempty(ProblemData.AxesHandle)
        figure(Position=[0 0 840 500]);
        ProblemData.AxesHandle = axes;
        axis(ProblemData.AxesHandle,"equal")
        xlim(ProblemData.AxesHandle,[-5 5])
        ylim(ProblemData.AxesHandle,[-5 5])
        zlim(ProblemData.AxesHandle,[-5 5])
        xlabel(ProblemData.AxesHandle,"x (m)")
        ylabel(ProblemData.AxesHandle,"y (m)")
        zlabel(ProblemData.AxesHandle,"z (m)")
        view(ProblemData.AxesHandle,45,30)
        title(ProblemData.AxesHandle,'Circular Current Loop')
        grid(ProblemData.AxesHandle,"on")
        box(ProblemData.AxesHandle,"on")
    end



    % Define circular loop geometry
    NumPoints = lcm(60,ProblemData.NumSegment);
    CompleteLoopAngle = linspace(0, 2*pi, NumPoints);  % Angular positions around the loop (radians)
    PointPerSegment = NumPoints/ProblemData.NumSegment;
    CompleteLoopAngle = circshift(CompleteLoopAngle,(ProblemData.CurrentSegment-1)*PointPerSegment);
    SegmentAngle = CompleteLoopAngle(1:PointPerSegment);
    LoopAngle = CompleteLoopAngle([PointPerSegment:end 1]);
    LoopRadius = 2;  % Radius of the current loop (meters)
    
    % Calculate Cartesian coordinates of the loop
    SegmentX = LoopRadius * cos(SegmentAngle);
    SegmentY = LoopRadius * sin(SegmentAngle);
    SegmentZ = 0 * SegmentAngle;
    LoopX = LoopRadius * cos(LoopAngle);
    LoopY= LoopRadius * sin(LoopAngle);
    LoopZ= 0 * LoopAngle;  % Loop lies in the xy-plane
    
    % ---- Start Plotting -------------------------------------------
    hold(ProblemData.AxesHandle,"on")

    % ---- Current Loop
    delete(findobj('Tag','Loop','Parent',ProblemData.AxesHandle));
    LoopPlotHandle = plot3(ProblemData.AxesHandle,...
        LoopX, LoopY, LoopZ, ...
        LineWidth=4, ...
        DisplayName="I = " + ProblemData.Current + " A, R = 2 m", ...
        SeriesIndex=1, ...
        Tag="Loop");
    ForLegend = LoopPlotHandle;

    % ---- Plot Current Direction
    delete(findobj('Tag','CurrentDir','Parent',ProblemData.AxesHandle));
    DirX = [LoopRadius LoopRadius LoopRadius];
    DirY = [-0.4 0 -0.4];
    DirZ = [-0.4 0 0.4];
    plot3(ProblemData.AxesHandle,...
        DirX, DirY, DirZ, ...
        LineWidth=2, ...
        SeriesIndex=1,...
        Tag="CurrentDir");

    % ---- Plot Current Segment
    delete(findobj('Tag','SegmentPlot','Parent',ProblemData.AxesHandle));
    SegmentPlot = plot3(ProblemData.AxesHandle,...
        SegmentX, SegmentY, SegmentZ,...
            LineWidth=4,...
            SeriesIndex=1,...
            Tag="SegmentPlot");
    if opts.HighlightSegment
        SegmentPlot.SeriesIndex = 2;
    end

    % ---- Query Point
    if opts.ShowQueryPoint
        % Set the query point for the magnetic field calculation
        delete(findobj('Tag','QueryPoint','Parent',ProblemData.AxesHandle));
        QueryPointHandle = scatter3(ProblemData.AxesHandle,...
            ProblemData.QueryPoint(1),...
            ProblemData.QueryPoint(2),...
            ProblemData.QueryPoint(3),...
            'filled',...
            SeriesIndex=5,...
            DisplayName="Query Point",...
            Tag="QueryPoint");
        ForLegend = [ForLegend, QueryPointHandle];
    end

    % ---- Distance Vector
    SegmentPosition = [median(SegmentX) median(SegmentY) median(SegmentZ)];
    DistanceVector = ProblemData.QueryPoint - SegmentPosition;
    delete(findobj('Tag','R','Parent',ProblemData.AxesHandle))
    if opts.ShowDistanceVec
        quiver3(ProblemData.AxesHandle,...
            SegmentPosition(1),SegmentPosition(2),SegmentPosition(3),...
            DistanceVector(1),DistanceVector(2),DistanceVector(3),...
            Tag="R",...
            SeriesIndex=6,...
            LineWidth=2,...
            AutoScale="off",...
            DisplayName="$\vec{r}$");
    end

    % ---- Show Infitesimal field
    dl = [SegmentX(end)-SegmentX(1); SegmentY(end)-SegmentY(1); SegmentZ(end)-SegmentZ(1)];
    dB = ProblemData.Current * cross(dl,DistanceVector) / norm(DistanceVector)^2;
    ProblemData.MagneticField = ProblemData.MagneticField + dB;
    delete(findobj('Tag','dB','Parent',ProblemData.AxesHandle))
    if opts.ShowdB
        dBHandle = quiver3(ProblemData.AxesHandle,...
            ProblemData.QueryPoint(1),ProblemData.QueryPoint(2),ProblemData.QueryPoint(3),...
            dB(1),dB(2),dB(3),...
            Tag="dB",...
            SeriesIndex=4,...
            LineWidth=2,...
            AutoScale="off",...
            DisplayName="$dB$");
        ForLegend = [ForLegend, dBHandle];
    end

    % Show total field
    delete(findobj('Tag','B','Parent',ProblemData.AxesHandle))
    if opts.ShowTotalField
        BHandle = quiver3(ProblemData.AxesHandle, ...
            ProblemData.QueryPoint(1),ProblemData.QueryPoint(2),ProblemData.QueryPoint(3),...
            ProblemData.MagneticField(1),ProblemData.MagneticField(2),ProblemData.MagneticField(3),...
            Tag="B",...
            SeriesIndex=7,...
            LineWidth=2,...
            AutoScale="off",...
            DisplayName="$B$");
        ForLegend = [ForLegend, BHandle];
    end

    % Stop Plotting
    hold(ProblemData.AxesHandle,"off")

    % Add Legend
    legend(ForLegend,Location="bestoutside",Interpreter="latex")

end
%%
%[text] ![Try this icon](text:image:3625) **Try.** Enter a point where you would like to compute the field.
CurrentLoop = GenerateCurrentLoop(CurrentLoop,"QueryPoint",[0,0,1]);  %[control:editfield:4455]{"position":[60,67]} %[control:button:48df]{"position":[69,70]}
CurrentLoop = PlotCurrentLoop(CurrentLoop,ShowQueryPoint=true);
%%
%[text] To simplify the integral in (3), we approximate its value by dividing the current loop into many small segments and summing their individual contributions.
%[text] ![Try this icon](text:image:23c7) **Try.** Use the spinner below to select your number and segment and visualize their size.
CurrentLoop = GenerateCurrentLoop(CurrentLoop,"MagneticField",[0 0 0]);
NumSegment = 8; %[control:spinner:9add]{"position":[14,15]}
  %[control:button:028c]{"position":[1,2]}
CurrentLoop = GenerateCurrentLoop(CurrentLoop,"NumSegment",NumSegment);
CurrentLoop = PlotCurrentLoop(CurrentLoop,ShowQueryPoint=true,ShowdB=true,HighlightSegment=true);
%%
%[text]{"align":"center"} $\\vec{dB}\_{seg}(\\vec{r}) = \\frac{\\mu\_0}{4\\pi} { \\frac{I\\vec{d\\mathcal{l}} \\times \\hat{r}}{r^2} } \\qquad (3)\n$
%[text] ![Try this icon](text:image:4c15) **Try.** Run the simulation below to see how the individual field pieces combine to form the total field.
  %[control:button:721c]{"position":[1,2]}
CurrentLoop = GenerateCurrentLoop(CurrentLoop,"NumSegment",NumSegment,"CurrentSegment",1);
CurrentLoop = PlotCurrentLoop(CurrentLoop,ShowQueryPoint=true);
CurrentLoop = GenerateCurrentLoop(CurrentLoop,"MagneticField",[0 0 0]);
pause(0.3);
for iSeg = 1:NumSegment
    CurrentLoop = GenerateCurrentLoop(CurrentLoop,"NumSegment",NumSegment,"CurrentSegment",iSeg);
    title(CurrentLoop.AxesHandle,"Select segment #"+iSeg)
    MagneticField = CurrentLoop.MagneticField; % Store magnetic field
    CurrentLoop = PlotCurrentLoop(CurrentLoop,HighlightSegment=true);
    pause(0.3);
    CurrentLoop = PlotCurrentLoop(CurrentLoop,HighlightSegment=true,ShowDistanceVec=true);
    pause(0.3);
    CurrentLoop = PlotCurrentLoop(CurrentLoop,HighlightSegment=true,ShowdB=true);
    pause(0.3);
    CurentLoop.MagneticField = MagneticField; % Reset magnetic field
    CurrentLoop = PlotCurrentLoop(CurrentLoop,HighlightSegment=true,ShowTotalField=true);
    pause(0.3);
end
%%
%[text] %[text:anchor:TMP_6e2b] ## Ampère's Circuital Law
%[text] Ampère's Circuital Law provides a powerful method for calculating magnetic fields when there is sufficient symmetry. It states that the line integral of the magnetic field around a closed loop equals μ₀ times the current enclosed by the loop:
%[text]{"align":"center"} $\\oint \\vec{B} \\cdot d\\vec{l} = \\mu\_0 I\_{\\text{enclosed}} \\qquad (5)$
%[text] Before we continue, we should look at how we can use this law to compute the magnetic field in a simple case: an infinitely long wire.
%[text] ![Try this icon](text:image:53a0) **Try.** Click the button below to visualize the wire.
PlotAmpereExample(ConfigType="Wire",ShowAmperian=false);   %[control:button:2b51]{"position":[58,59]}
%%
%[text] Because the wire is infinitely long, the field should not depend on the position along the Z axis.
%[text] ![](text:image:77fd) **Demonstration.** Click the button below to see a step by step explanation on how to use Ampere's law.
  %[control:button:083c]{"position":[1,2]}
% Show setup
handle = PlotAmpereExample(ConfigType="Wire",ShowAmperian=false,WithAnnotation=true);
t = annotation(handle,"textbox",Position=[0.65 0.1 0.3 0.8],LineStyle="none",Interpreter="latex");
t.String = "\bf 1. We are picking an Amperian line";
for frame = 1:15
    drawnow
end
pause(2)

% Show Amperian line
t.String = [t.String;...
    "A circle around the straight wire";...
    ""];
handle = PlotAmpereExample(ConfigType="Wire",ShowAmperian=true,Figure=handle);
for frame = 1:15
    drawnow
end
pause(2)

% Show B field
t.String = [t.String;...
    "\bf 2. Determine the field direction along the path using the right-hand rule";...
    ""];
handle = PlotAmpereExample(ConfigType="Wire",ShowAmperian=true,Figure=handle,ShowB=true);
for frame = 1:15
    drawnow
end
pause(2)

% Count the current enclosed in Amperian line
t.String = [t.String;...
    "\bf 3. Count the current enclosed in the Amperian line";...
    "$$I_{total} = I_{wire}$$";
    ""];
handle = PlotAmpereExample(ConfigType="Wire",ShowAmperian=true,Figure=handle,ShowB=true);
for frame = 1:15
    drawnow
end
pause(2)

% Solve the integral
t.String = [t.String;...
    "\bf 4. Solve the integral";...
    "$$\oint \vec{B} \cdot d\vec{l} = 2\pi R B$$";
    ""];
handle = PlotAmpereExample(ConfigType="Wire",ShowAmperian=true,Figure=handle,ShowB=true);
for frame = 1:15
    drawnow
end
pause(2)

% Rearrange the results
t.String = [t.String;...
    "\bf 5. Re-arrange the results";...
    "$$B = \frac{\mu_0 I_{wire}}{2\pi R}$$"];
for frame = 1:15
    drawnow
end
pause(2)
%%
%[text] **Tips**. The right‑hand rule gives you the **direction** of that magnetic field when applying Ampère’s law to real situations like straight wires or coils.
%[text] - Point the **thumb** of your **right hand** in the direction of the conventional current $I$
%[text] - Your **fingers curl** naturally around the wire or current‑carrying conductor. \
%%
function handle = PlotAmpereExample(opts)
arguments
    opts.ConfigType (1,1) string {mustBeMember(opts.ConfigType,["Wire","Solenoid","Toroid"])}
    opts.ShowAmperian (1,1) logical = false;
    opts.ShowB (1,1) logical = false;
    opts.Figure (1,1) = figure(Position=[0 0 840 500]);
    opts.WithAnnotation (1,1) logical = false;
end

    % Rename arguments
    ConfigType = opts.ConfigType;
    handle = opts.Figure;

    ax = findall(opts.Figure.Children, 'Type', 'axes');
    if isempty(ax)
        if opts.WithAnnotation
            ax = axes(handle,"OuterPosition",[0 0 0.6 1]);
        else
            ax = axes(handle,"OuterPosition",[0 0 1 1]);
        end
    end
    delete(ax.Children)

    % Start drawing things
    switch ConfigType
        case "??"
            warning("Select a configuration type.")
            return
        case "Wire"
            ax = plotWire(ax);
            title(ax,"Ampère's Law: Straight Wire")
            if opts.ShowAmperian
                ax = amperianWire(ax,opts.ShowB);
            end
        case "Solenoid"
            ax = plotSolenoid(ax);
            title(ax,"Ampère's Law: Solenoid Wire")
            if opts.ShowAmperian
                ax = amperianSolenoid(ax,opts.ShowB);
            end
        case "Toroid"
            plotToroid(ax);
            title(ax,"Ampère's Law: Toroidal Wire")
            if opts.ShowAmperian
                ax = amperianToroid(ax,opts.ShowB);
            end
    end

    % Set axis properties
    axis(ax,"equal");
    grid(ax,"on");
    xlabel(ax,"X");
    ylabel(ax,"Y");
    zlabel(ax,"Z");
    xlim(ax,[-4 4])
    ylim(ax,[-4 4])
    zlim(ax,[-4 4])

    % Set viewing angle
    view(ax,45, 30);
    % Add lighting for better visualization
    camlight(ax,'headlight');
    lighting gouraud;

end


function ax = plotWire(ax)
    plot3(ax,[0 0 0.1 0 -0.1 0 0], [0 0 0.1 0 -0.1 0 0],[-3 0 -0.3 0 -0.3 0 3], SeriesIndex=2, LineStyle="-", LineWidth=3, DisplayName="Current Wire")
end

function ax = amperianWire(ax,showB)
    % Show circular Amperian loop around straight wire
    theta = linspace(0, 2*pi, 100);
    r = 2;
    x_loop = r * cos(theta);
    y_loop = r * sin(theta);
    z_loop = 0 * y_loop;
    hold(ax,"on")
    plot3(ax,x_loop, y_loop,z_loop, SeriesIndex=1, LineWidth=2, LineStyle="--", DisplayName='Amperian Loop')
    
    % Add arrows to show field direction
    if showB
        n = 5;
        theta_arrows = linspace(0,(2-2/5)*pi,n);
        dl = [0;0;1];
        dr = [r*cos(theta_arrows); r*sin(theta_arrows); 0*theta_arrows];
        B = 0*dr;
        for i = 1:n
            B(:,i) = cross(dl,dr(:,i));
        end
        quiver3(ax,dr(1,:), dr(2,:), dr(3,:), B(1,:),B(2,:),B(3,:), SeriesIndex=3,  LineWidth=2, MaxHeadSize=0.5,AutoScale="off")
        hold(ax,"off")
    end
end

function ax = plotToroid(ax)
    % Toroid parameters
    R = 3;  % Major radius (distance from center of tube to center of toroid)
    r = 1;  % Minor radius (radius of the tube)
    
    % Wire parameters
    N = 20;  % Number of loops around the toroid
    
    % Create parameter for the wire path
    % u goes around the major circle (0 to 2*pi)
    % For N loops, v must go from 0 to N*2*pi as u goes from 0 to 2*pi
    n_points = 1000;  % Number of points along the wire
    u = linspace(0, 2*pi, n_points);
    v = linspace(0, N*2*pi, n_points);
    
    % Parametric equations for wire path on toroid surface
    X = (R + r*cos(v)) .* cos(u);
    Y = (R + r*cos(v)) .* sin(u);
    Z = r * sin(v);
    
    % Create figure
    hold(ax,"on");
    
    % Plot the wire
    plot3(ax,X, Y, Z, SeriesIndex = 2, LineWidth=2);
    
    % Optional: Draw a semi-transparent toroid surface for reference
    u_surf = linspace(0, 2*pi, 40);
    v_surf = linspace(0, 2*pi, 40);
    [U_surf, V_surf] = meshgrid(u_surf, v_surf);
    
    X_surf = (R + r*cos(V_surf)) .* cos(U_surf);
    Y_surf = (R + r*cos(V_surf)) .* sin(U_surf);
    Z_surf = r * sin(V_surf);
    
    surf(ax,X_surf, Y_surf, Z_surf, FaceColor=[0.8 0.8 0.8], ...
        FaceAlpha=0.15, EdgeColor="none");
    
    hold(ax,"off");
end

function ax = amperianToroid(ax,showB)
    % Show circular Amperian loop around straight wire
    theta = linspace(0, 2*pi, 100);
    r = 3;
    x_loop = r * cos(theta);
    y_loop = r * sin(theta);
    z_loop = 0 * y_loop;
    hold(ax,"on")
    plot3(ax,x_loop, y_loop,z_loop, SeriesIndex=1, LineWidth=2, LineStyle="--", DisplayName='Amperian Loop')
    
    % Add arrows to show field direction
    if showB
        n = 5;
        theta_arrows = linspace(0,(2-2/5)*pi,n);
        dl = [0;0;1];
        dr = [r*cos(theta_arrows); r*sin(theta_arrows); 0*theta_arrows];
        B = 0*dr;
        for i = 1:n
            B(:,i) = cross(dl,dr(:,i));
        end
        quiver3(ax,dr(1,:), dr(2,:), dr(3,:), B(1,:),B(2,:),B(3,:), SeriesIndex=3,  LineWidth=2, MaxHeadSize=0.5,AutoScale="off")
    end
    hold(ax,"off")
end

function ax = plotSolenoid(ax)
    % Solenoid parameters
    R = 1;      % Radius of the cylinder
    L = 6;      % Length of the solenoid
    N = 20;     % Number of loops (turns)
    
    % Wire parameters
    n_points = 1000;  % Number of points along the wire
    
    % Create parameter for the wire path
    % t goes from 0 to 1 along the length
    t = linspace(0, 1, n_points);
    
    % Parametric equations for helical wire path
    theta = 2*pi*N*t;  % Angle completes N full rotations
    X = R * cos(theta);
    Y = R * sin(theta);
    Z = L * t;  % Linear progression along z-axis
    
    % Create figure
    hold on;
    
    % Plot the wire
    plot3(X, Y, Z, SeriesIndex=2, LineWidth=2);
    
    % Optional: Draw a semi-transparent cylinder surface for reference
    theta_surf = linspace(0, 2*pi, 40);
    z_surf = linspace(0, L, 40);
    [Theta_surf, Z_surf] = meshgrid(theta_surf, z_surf);
    
    X_surf = R * cos(Theta_surf);
    Y_surf = R * sin(Theta_surf);
    
    surf(X_surf, Y_surf, Z_surf, FaceColor=[0.8 0.8 0.8], ...
        FaceAlpha=0.15, EdgeColor="none");
    
    hold off;
end

function ax = amperianSolenoid(ax,ShowB)
    Z = [-1 7 7 -1 -1];
    X = [ 0 0 2  2  0];
    Y = [ 0 0 2  2  0];
    hold(ax,"on")
    plot3(ax,X,Y,Z, SeriesIndex=1, LineWidth=2, LineStyle="--", DisplayName='Amperian Loop')

     % Add arrows to show field direction
    if ShowB
        Z = linspace(0.5,5.5,5);
        Y = 0*Z;
        X = 0*Z;
        Bz = X + 1;
        By = X;
        Bx = X;
        quiver3(ax,X,Y,Z,Bx,By,Bz, SeriesIndex=3,  LineWidth=2, MaxHeadSize=0.5,AutoScale="off")
    end
    hold(ax,"off")
end

%%
%[text] ![](text:image:569d) **Reflect.** How was the Amperian line selected for the demonstration above? Was it just a pure guess, or perhaps an educated guess using symmetry consideration?
%%
%[text] Now that you have seen how to use Ampere's law for a simple wire, we should try to apply it for common geometry such as toroid and solenoid.
%[text] 
%[text] ![](text:image:7600) **Exercise 4.** Use the controls below to select your case and generate a problem statement.
AmpereExercises = GenerateAmpereProblem("??"); %[control:dropdown:4f75]{"position":[41,45]}
  %[control:button:5935]{"position":[1,2]}

function y = GenerateAmpereProblem(Type)
arguments
 Type (1,1) string
end
    
    switch Type 
        case "Solenoid"
            y.Config = "Solenoid";
            Options = ["'A) A circular loop centered on the axis of the solenoid and lying in the plane perpendicular to the solenoid'";...
                "'B) A square loop lying entirely outside the solenoid'";...
                "'C) A circular loop that wraps around the outside of the solenoid, following the windings'";...
                "'D) A rectangular loop with one side inside the solenoid and one side outside, oriented parallel to the solenoid's axis'"];
            Question = "'Which of the following Amperian loops is most appropriate for calculating the magnetic field inside a long solenoid using Ampère s Law?'";
        case "Toroid"
            y.Config = "Toroid";
            Options = ["'A) A straight line passing through the center of the toroid'";...
                "'B) A circular loop centered on the axis of the toroid and lying in the plane of the windings'";...
                "'C) A circular loop lying perpendicular to the plane of the toroid'";...
                "'D) A square loop surrounding the entire toroid'"];
            Question = "'Which of the following Amperian loops is most appropriate for calculating the magnetic field inside a toroid using Ampère s Law?'";
        case "??"
            warning("Please, select either Toroid or Solenoid.")
            y = [];
            return
    end

    PlotAmpereExample(ConfigType=y.Config);
    displayFormula(Question)
    for i = 1:4
        displayFormula(Options(i))
    end
end
%%
CheckExercise4(AmpereExercises,"??") %[control:dropdown:27c0]{"position":[32,36]}

function CheckExercise4(Prob,Answer)
    if ~isfield(Prob,"Config")
        warning("Generate a problem above before to submit an answer.")
        return
    end
    switch Prob.Config
        case "Solenoid"
            switch Answer
                case "A"
                    displayFormula("'Incorrect. This loop is useful for wires, not for the solenoid's axial field.'")
                case "B"
                    displayFormula("'Incorrect. No current is enclosed, so Ampère's Law gives zero.'")
                case "C"
                    displayFormula("'Incorrect. This does not match the field's direction or symmetry.'")
                case "D"
                    displayFormula("'Correct. This loop takes advantage of the solenoid's symmetry and allows you to relate the field inside to the enclosed current.'")
                    PlotAmpereExample(ConfigType=Prob.Config,ShowAmperian=true);
            end
        case "Toroid"
            switch Answer
                case "A"
                    displayFormula("'Incorrect. A straight line does not exploit the symmetry of the toroid.'")
                case "B"
                    displayFormula("'Correct. This loop matches the symmetry and allows for easy application of Ampère's Law.'")
                    PlotAmpereExample(ConfigType=Prob.Config,ShowAmperian=true);
                case "C"
                    displayFormula("'Incorrect. The field is not constant or tangent along such a loop.'")
                case "D"
                    displayFormula("'Incorrect. A square loop does not match the symmetry and complicates the calculation.'")
            end
    end
end
%%
%[text] Now that you have selected the correct Amperian line, you can count the current enclosed in the Amperian line
%[text] ![](text:image:4786) **Exercise 5.** Determine the total current enclosed by the Amperian loop.
%%
  %[control:button:08ca]{"position":[1,2]}
AmpereExercises = GenerateProblem5(AmpereExercises);

function y = GenerateProblem5(Prob)
    if ~isfield(Prob,"Config")
        displayFormula('"Please generate a problem and complete exercise 4 before to attempt exercise 5."')
    end
    Prob.NumLoop = sym(randi([20 40]));
    Prob.Current = sym(randi([2 7]));
    displayFormula(["'What would be the value of '" "I_enclosed" "' with:'"])
    displayFormula(["'  - Number of loop: '" "N == Prob.NumLoop"])
    displayFormula(["'  - Current: '" "I == Prob.Current" "' A'"])
    displayFormula("' '")
    displayFormula("'You can type your answer below in Ampere or directly using the symbol N and I for number of loops and current.'")
    Prob.Current = separateUnits(Prob.Current);
    y = Prob;
end
%%
CheckExercise5(AmpereExercises,"") %[control:editfield:0b04]{"position":[32,34]}
  %[control:button:8d25]{"position":[1,2]}

function CheckExercise5(Prob,Answer)
    if ~isfield(Prob,"Config")
        displayFormula('"Please generate a problem and complete exercise 4 before to attempt exercise 5."')
    end
    if ~isfield(Prob,"NumLoop")
        displayFormula('"Generate a problem above before to submit your answer."')
    end
    
    % Right Answer:
    N = Prob.NumLoop;
    I = Prob.Current;
    RightAnswer = double(N*I);
    Case1 = double(I);
    if Answer ~= ""
        Answer = double(eval(Answer));
    else
         displayFormula('"Please add your answer in the edit field above."')
        return
    end

    % Feedback
    if IsClose(Answer,RightAnswer)
        displayFormula('"Correct! You calculated the total count of current inside the Amperian line correctly."')
    elseif IsClose(Answer,Case1)
        displayFormula('"Incorrect, you accounted for only one of the current through the Amperian line, but there is many winding, so how many current total?"')
    else
        displayFormula('"Incorrect, please try again. Ask yourself how many time does the wire goes inside the Amperian line?"')
    end
    
end
%%
%[text] The next step is to calculate the integral $\\oint \\vec{B} \\cdot d\\vec{l}$.
%[text] If you need to learn more about line integral, you should consider reviewing our line integral script in the multivariable integral module [here](https://github.com/MathWorks-Teaching-Resources/Multivariable-Integrals/blob/release/Scripts/LineIntegrals.mlx).
%[text] ![](text:image:04e1) **Exercise 6.** Enter your answer the the edit field below.
%[text] Use only the symbolic variables **B**, **L**, **R,** and constants like **pi** when entering your expression for the magnetic field.
%%
  %[control:button:47d8]{"position":[1,2]}
if isfield(AmpereExercises,"Config")
    switch AmpereExercises.Config
        case "Toroid"
            displayFormula("'- The Amperian line radius is (R)'")

        case "Solenoid"
            displayFormula("'- Consider the solenoid length to be (L) and approximate the field to be constant along the central segment and null everywhere else.'")
    end
    PlotAmpereExample(ConfigType=AmpereExercises.Config,ShowAmperian=true,ShowB=true);
end

%%
CheckExercise6(AmpereExercises,"") %[control:editfield:93c5]{"position":[32,34]}
  %[control:button:1bfb]{"position":[1,2]}

function CheckExercise6(Prob,Answer)

    if Answer ~= ""
        Answer = str2sym(Answer);
    else
         displayFormula('"Please add your answer in the edit field above."')
        return
    end
    if ~isfield(Prob,"Config")
        displayFormula('"Please generate a problem and complete exercise 4 before to attempt exercise 6."')
    end
    
    % Right Answer:
    syms B L R
    switch Prob.Config
        case "Toroid"
            RightAnswer = 2*pi*B*R;
        case "Solenoid"
            RightAnswer = B*L;
    end

    % Feedback
    if isequal(Answer,RightAnswer)
        displayFormula('"Correct! You have computed the integral correctly."')
    else
        displayFormula('"Incorrect, remember that in your case the field can be considered constant along the integration line."')
    end
    
end
%%
%[text] Congratulations if you made it this far! You have correctly calculated the right hand side and left hand side of:
%[text]{"align":"center"} $\\oint \\vec{B} \\cdot d\\vec{l} = \\mu\_0 I\_{\\text{enclosed}} \\qquad (5)$
%[text] The last step to express the field in your configuration is to rearrange the equation.
%[text] ![](text:image:205c) **Exercise 7.** Rearrange the solution and enter the expression for the magnetic field below:
%[text] Use only the symbolic variables **B**, **L**, **R**, **mu0**, **N**, and **I** (and constants like **pi**) when entering your expression for the magnetic field.
CheckExercise7(AmpereExercises,"") %[control:editfield:62cd]{"position":[32,34]}
  %[control:button:5586]{"position":[1,2]}


function CheckExercise7(Prob,Answer)

    if Answer ~= ""
        Answer = str2sym(Answer);
    else
        displayFormula('"Please enter your expression for the magnetic field in the field above."')
        return
    end

    if ~isfield(Prob,"Config")
        displayFormula('"Please generate a problem and complete Exercise 4 before attempting Exercise 7."')
        return
    end
    
    % Right Answer:
    syms B L R mu0 N I 
    switch Prob.Config
        case "Toroid"
            RightAnswer = mu0 * N * I / (2*pi*R);
        case "Solenoid"
            RightAnswer = mu0 * N * I / L;
    end

    % Feedback
    if isequal(Answer,RightAnswer)
        displayFormula('"Correct! You have evaluated the integral properly."')
    else
        displayFormula('"Incorrect. Remember that the enclosed current is I_{enclosed} = N * I."')
    end
    
end
%%
%[text] ![](text:image:071e) **Reflect.** Notice how Ampère's law provides exact solutions when symmetry allows us to evaluate the line integral easily. This is analogous to how Gauss's law simplifies electric field calculations for symmetric charge distributions.
%[text] This activity demonstrated  that, for both the toroid and the solenoid, increasing the number of loops strengthens the magnetic field even when the current remains unchanged. There is a proportional relationship between the field and the enclosed current $I\_\\text{enclosed}=NI$.
%%
%[text] %[text:anchor:TMP_2b66] ## Conclusion
%[text] We have seen how magnetic fields originate from electric currents and how they influence moving charges without doing work. From the Lorentz force to the Biot–Savart and Ampère’s laws, these principles give us powerful tools to analyze and visualize magnetic phenomena. Mastering these concepts is essential for understanding electromagnetism and its applications in modern technology.
%%
function tf = IsClose(A,B)
    lhs = abs(A-B);
    rhs = max(1e-4,1e-4*max(abs(A),abs(B)));
    tf = lhs <= rhs;
end
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%%
%[text] ## Help us Improve
%[text] [Share your feedback](<matlab: ShareFeedback>) to help us improve this module.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"hidecode","rightPanelPercent":40}
%---
%[text:image:9173]
%   data: {"align":"baseline","height":191,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAs0AAAHECAYAAADCqBfUAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAg\nAElEQVR4nOydeZwU1bn3f1XdPcMwMMDAMCwiEARcohE3wA2XqFlukpt7s9wsbrka9XrVmPu+970J\nmPd+3gDXvIvgFo0izAxijInRaOISNYmaxSWJGhOzKKi4scMswCzdXe8f3afm1NPP2aprhhmo3+fT\nn+46y3NObae+9fRTp7wgCAKkSpUqVapUqVKlSpVKKX9fdyBVqlSpUqVKlSpVqqGu7L7uQKpUqVKl\nGgLyPHVe+odkqlSpUqWe5lSpUqVyUT6fjyz39vaGv7u7u9Hd3W1ta8+ePU5t79mzx6mOdXkdMIt8\nU5lUqVKl2s+VeppTpUp1QCqfzyOb7R8Ce3t7UVNTAwC49NJLceKJJ0bKe2Vo9Ag8qtJ1Uj1KMtiP\nmHzx3HPZ9J5MBi80NobLC7ZuLf3wvNTrnCpVqgNWXvogYKpUqYazVPDb09ODO++8E7lcrqKO53ks\n\/KrANwlQHiyJId00tH\/u859n098ZNQrvjhrF1g+CANtHjMCOujpgyRIEQVBRzvM8nKuA8VSpUqUa\nzkqhOVWqVENDHIAGAXp6erBu3boIGAv5Ph9hpkq3AWVbIB6KwGyrT3360xVpv5syBQCwYeXKSPrM\nq66qKBsEAdavWKEFdA6oi8ViZDkF7FSpUg0npdCcKlWqQdfatWsBRGHL9\/2KcIG71q2rqKuCVQ6U\ndd5jnS1VmeEMyrL+4R\/\/MbK8Y+RI\/ILZJ2L5fV\/5SoWN9ePHA0uWVJSlNig8c5ccCtOpBztVqlRD\nUSk0p0qVasAkw7EAWM6TK37TkIHv3X13mG8bOqGTCaI5u64eZ7psGy4xWPr7T36yIu3+++5jy1LY\nlb3O+UwGbzU2Ili8uKKszg5N1wE2VzcF7FSpUu0rpQ8CpkqVqiqtXbu2wmMMlMAlk8mE6TKwyl5h\nHZTK9WW5xhSrwjWqtUvruebFVVwA\/\/gnPlGR9sCPfmScRkm0J69LrljExK4ubPuv\/wrjm019o4Cr\n2jY6b7Q4Jig803p33nlnpE3RVgrTqVKliqsUmlOlSmWltra2yLIAUd\/3I\/AjA6oKjjlY4sD2U5\/+\nNH54772Rei6eYlcvtEuZ4RSqoQNZsd11ZcS6brzpJky\/4oowfXRPD3K7dmGztO\/iwLNNGXoDJZZV\nnmr5eBKAHQQB1q1bF5ZLYTpVqlQuSsMzUqVKFZEMxzrvsMlrbPNbXvY8DzOuvBJHv\/VWJP9H99\/P\n1lNpoMI1uDaGAjjbDuEf+ehHK9J+8uMfx2pz2uWXR5bzmQzeIQ8Q2vQrDjy75JtirGWYpmkpTKdK\nlYoq9TSnSnUASgXGnueFs1TIaaZYZLpsAmaXGStsQiviwm+1dTlb1crVjxG3zYcfeijW262CIMDb\n3\/52BJx7a2vhL19e8WCgKK9aJ9F3G3DWlVO1oYJmIc4bLYd9BEEQhnkUi8UUpFOlOsCVQnOqVPux\nVHCcyWQqQNUFjoFKmLUFZio5feNNN+EDH\/+4th2Vkgqd2Nfe44Fo\/0Mf\/nBV7XBxyHL9EX198D0P\nIPtKgKZtW1ycMtdXFTyb4px1EC2fG5wnWj4O03jpVKkOTKXhGalSDXO1trY6AbD8oJ4JNDngUaWp\nbKjqqMp\/9O\/+LrL80E9+kuiDea6yhfahrLPPOSey\/NNHHzXWMU0TB0TDNN6aPLlUtjybhotcZxgx\neZZt0nQwrVp3XViHSJdtKGfxMB2f6WU5VaohqRSaU6UaZmpra6uAVBmEhWweyJPTbOHYxmNsA+Oq\nvA9\/5CMVaY88\/DDbpq2S8kIPR4D+4FlnVaQ99tOfsmXjXA4O+pd\/QRAEyGcyeG\/iRDZEQyWX9kxT\n0dF0E\/Rz9nSwrGpf\/pbLyd9f+OIXNWtmofQynSrVkFAanpEq1RAXhWQaWmHjXZaXBwuOXUE1bpl9\n+SDfvg7liKMnHn88EstsMwUcJ1ovVyyieccObFXENos6cdvzPM9YV447NoV0qPpi64Gm7dH8T3\/m\nMxZrZSl5XVKATpVqnymF5lSphpgEJIs4SgHJMshynmMKqbYP4NmCqAmkkwLjV2bNwuHr10fSXF6L\nHUdJwq+NrcH6g+\/MD34wstyXy1WUqTa2+d1bb8XUyy4DUIptHt\/ejp1MbLOo47J9uJeW6MqrjhM5\n7liOYeZAWk7ngJhuA2qDvm1Rp55MBr2ZDDpyObwzalTE\/vwtW\/hKok8pPKdKNehKoTlVqn0s8bCe\nAAoKySrvsSoUg1seTDi2aUdn4+1vfxuHkxjcOA8DJqGkPNIqu4OtXz76qHbGDFMIhM2\/D\/V796Lw\nP\/4HOr71rTDNZv\/RWGBde6IcB7ecTdV5Q73KOm8zV1\/uB\/emRVnvNTTgvdGjI2nrV6wAAMy86ir4\niEL7c83NeoD2vBScU6UaZKXQnCrVIItCsjzFmy5GmYNnGy8zzdeVs8nT2VT1SVXPFh4HIoxisL3L\ngyUBWqefcYZz3Tie+yAI8O6tt2LKpZcCAHpqa9HZ0ODswbYFZbm8CZZNdnQwrfI2U9vcWxZlddXW\n4rWJE\/H69ddXQnp5+Y0bbmBjqIMgwKyrr8Zzzc2Rfs\/fsgUduRxqs1nUFgopPKdKNUhKoTlVqgGW\nmN2CQjL3oJ4MDqZwCx182oRh2MCrDmB0kBMHvpIoM9ThejCk62\/cBxlVU8HJ7YnvXKFQakeKbTY9\nlOe6jXWwrAJw2\/hlkc+1QWOY6Uwvsrpqa\/Gze+4JlzOo3I6qZTns4\/XrrwdQ8kaLtilE75k6FW9f\ney2KxSLOP\/98ZZ9SpUpVndLZM1KlSlgUkrkp3jhIlsvoQi\/k8tyyLhQjDhyr+kDrJgXGQGUsLgD8\n\/Gc\/s6pr004SIDzUYfrURYsiy089+SRbLolLQBAEmHLppQiCAIVMBpvL08\/ZzqRhmgkjbn1Vng7i\nbWbp4GZ4AYCdo0ahvrsbj91\/v3bGDXlZN0sHNxvHzKuuiizL5V\/9f\/8vrJMCdKpUySuF5lSpVNJB\nkXTatLS0wPd9JSRz3mNdmuqlIVyaDlhtH56jeXHDLmzbMLUDAOOvugpHvfxyJO0XP\/95VW261hvq\nUKzTKaeeWpH29FNPVWWTg0CqyZdcAgDYW1+PXY2NEWi2nTJO175L\/Tj5uinnhLgXxQDAlrFj8bu7\n7grLc\/apZ9lmGjvVN4XnPs\/Dm+PGldouz5UtzxudQnSqVNUrheZUqTg5ANNd69aVq8SDZJtQizie\nZZU9IZP3uFpvrQtkc\/VOO\/30SPqTv\/iFdd1qywxE3cHUyaecEln+5dNPW9Wr9nIw6ctfBgDkMxls\nScjbbNsvG6h3bYcu05fEAEBfNou\/HXww3rr5ZqX9aiGasxEEAWZceWWkXN738ea4cSXbX\/96pA05\nTjoIAhQKBVx44YUVfUqVKpVaKTSnSkXFgFFHLoeGvj5tte9L8Yum2OS4kGwCUV16HHjW2bS1r7Jn\nKr\/otNMiy6rwAhtbSdWJa3+wh9m40Gwr3foIcN5bX4\/2xkbgmmu09Vy2jSk22lQvbhhIEAQ46+yz\nK9J319XhV4pQDJNt1Su\/VX1VhXYIcJbLrB8\/vrRc9jjLdkW7qRc6VSp3pdCcKpUsCXSenTixAm6P\n2rq19LS6Qvf+4AfKeGQVLKogWgfWunRdTLOrLVvbrm2Z6gGVMbm68IKBBOCBCN8YyGH3pJNPrkj7\n1S9\/6WSjmv4JaC5ks9gyaVIEmuO2bdsf3QOLOps64OXeqAgAe+rq8Ksf\/UhZXwXSurZ04SEmiD74\nX\/81srxz5EjsHDkSweLFERCnYC6DsxwPfcEFF7D9TJXqQFYKzakOeImY5Elf\/zrG9PVVAN+GlSvD\nsr7v44wLLsD4PXvQWVuL0T09Ffbuv+++SH1br7ErJJu81To7tnn7yssMVMblvnL00dhx441W7Zja\nj5tfTVuDNdSeeNJJkeV8LofnLEJbbGWCTQHNANBbW4sdzc3GEI0kvcYm+7axzkEQsA+kAkD76NF4\n\/oc\/dOqfrQdZVZ6W40I7pl9xRWQ5n8ng7RUrWFgW3yqQlj3SqRc6VaqSUmhOdUBqzZo1yGQyAEog\nPOe\/\/Te81tiI2Tt3hmU2rFypjUGeedVVmL5zJxp3766w\/0DZAyXXk+vSPNeH72zhWVXHpg1Ori8Z\ncYFQWpaGGADRMINqbLtquMQyA8DCE0+MLP\/m1792qp\/EJaH54osBlLzNW6dMCcMEqlHS3mYTvHLz\nXP9l9my8c8stTv1zgWibeGsTRAtwDoIA3bkc3h0\/HpnFiyOxzXJ5Lo0DaeGJTr3QqQ5kpdCc6oDR\nmjVr4Pt+ONNFZJ7k5csxpaMDI\/N5ACVIEtAM8HMqi3If\/tSnUFOuR\/XjBx90fmjPJbQirifZJo7Z\nxXs8EADLQTMNMxisWObhBM0LFi6MLD\/zm99Y1XO9FOjKC2juGjMGu8eOLSUyczYPZB905Ux9oA+h\nAkB7QwN+f\/\/9kTQdoNvEOLt6pXV25OWD\/\/Vfw+U3m5uBIEBAZjKhdShUc3HQ1DNdLBZRLBbTBwpT\nHTBKoTnVfi8RfiFPCyeDnr98OQBg1vbtAPqBmZtfWRVKcfpnPoNR3d1s+w8\/9JCybzpI1sGzypZL\nG65lALeXY1QTzyx+01CDX\/\/qV1W3k1TdJOonrfkLFlSkPfvMM9o61V4CVPWbL74YXWPGoGvMmFLC\nEJiz2VQuCIKKB1CBUvzycw89ZLTtCtEusKyKkablgyDAtMsvD5fzmQzeLj8YyE0ByEEyF8ohh2vQ\n9DQWOtWBohSaU+2Xamlpged5yGQyPCjLLxdZuhTTd+5Etvy2r9evv94KlGUJe6o3hAlw1nmMk4Bk\n27CIJD3NNu3FtUuh2TbUYH\/3JqtEodkEzLaKc5mYeNFFKGSz2DZ1ailBA80DFZ\/sWo6b37ovl8Ov\nH3uMLW8KBVHl294YVAPRMjj3+T7ebWoqlV+yxMoe9S7L\/UgBOtWBqvQ12qn2G8nhF7lcrgKWKVAK\ncJzS2YlcEABe\/8tJTKDMxSZ7noeHH3oIZ3784xXhGh\/+yEfw6COPVNiqJtzCJZa5Woi2ace1zTht\neEuXWs\/GsK8gOMl2h4pPw2adVH0NazL7TtTR2ad2dce9CiQ5+7bb9pknnoCnAHV63tD25XwZPLl+\n037K5eR0+VXb1I6c9\/a3vx2Cc65YxNjdu9E+ahTg+xX9FG0Je0EQhH3nYDqTyYRlZHD2PC+ynmvX\nrkUQpHNCp9p\/lEJzqmEtGZRramoiQKwDZfHde+212NzYiBlbtoQ2uWnixG+b+OSfPfgg+9YwG481\nV54rpwvFsLFrE65hK5eQDVUb1YRyDLT2pQfape0T5s+vqr5QXFDnjtFsoYBR7e39cc0SVNn0jwNM\nXR91xzaFP1qOi6EX0xyqjlXOpgye8jc9N00QrQJrer7J3mwK6W\/dfDOmXX45PM\/D2N274XkeOpYt\nQ0C8zdSbTNdDzqMwLS\/L\/ZHhOpPJYO3atSgUCqn3OdWwVgrNqYalRPgFBWX5WxWSIeeNKM+5zF0U\nVZBrExbx6COP4JwPfShS5uxzzsHjir95Ve3RPFVaNRBtky+XcwWxuFCtah9VQmw1ELw\/hHCYVI1X\nWdaWVasw8aKLMGL3buwuv6XO1b7puHYJ1eCOXVGHm9v6l08\/HXrJbSBdB8lcP20hWrUtTBBNx78g\nCDCmqwsdo0ez\/Rb9pN5iUZbLE9\/yh\/NCC4D2fR\/r1q1DoVBIvc+phqXSmOZUw0ayV1lMFycG9EiM\nMio9zSJNlueV4pkBhJ7mjTfdFLFjA7I64ObeIibA2cWTbONpdvHc2oDLYAKyqh2bB9uSANmh7Om2\n1XHHHx9Z\/u3zz1vVi3sJsKnX9M\/\/jEI2i+0HHVRKsHwYMG57tLxNHRo335fL4c1DDsGm226L3R8T\nzKtil22WbeOhRVoQBDjoX\/4lTHtj6lRkikV2GkAufpmLq9aVkT9yHjcDh5h9I50HOtVwUQrNqYa0\nVq9eHXoouNkvOE+yano4gAHLpUsxoaMD9Xv3wvM8bLzpJiMoqwBWBa3cG8WeePxxZXkbT7MNRJts\ncPkuHmfbdl37QUXB+bmPfcwavlzaGoog7KK40GyjOJeJIAgw8aKLAAC7x46tmHquGttJ1AuCoAKY\nO8eOxZYpU7D59tsr6thCsk1+UlDtAtBTL7sMQOmhwE3NzaVy0tsCdfYpFKvK0thnOZ0LB5HLpN7n\nVMNBaXhGqiGn1atXh5BcW1tbAcYcKKvCMESerEiYhu9jhPQWQM5TGgeU5bS+XA4AkOvrC9PP\/OAH\n8fOf\/UxbT2dXl26bP5AvKolT3rVuUiEnSdsYLPiWIeTY444b0H7QEANTf0SdrXfcgaZ\/\/meM6OrC\nHhGiwYQF2Nqk9l3K03pcfQ6YRVlaXo4lVoVOcPk0\/IIL3zBtE11oh6k\/ufIsQbrYZRpaIveRlufG\nKjnWGeBn4pDDPoSdTCaDO++8E4VCIfU+pxqSSqE51ZDQ6tWrw0GzpqYmMoOFKlZZlSaWZXHxzADQ\n0NWFXLFYESdbDSjTsk8\/8giO+vSnMWHHDraMrk1d+Tj5Lp7kwfDS2njV2fwYoSO27VdTbjCl69Pv\nf\/c7xO2xLn5XV153LsiAZLKns2kTt6yyRUVfArO3vh5b77gDYqQweZfpQ3eqdTMBNE0zQTQHyjYQ\n\/e6tt2LqZZchCAI0bd+ObRMmAMuXh95mW4Dm+l0sgzi3niaApuEbxWIxEvucTl2XaigpheZU+1Sr\nV69GNps1grL8W74IqwCWgz5uVowdjY0YW34Ntud5Si+1KyjT9Jd\/8APM\/+hHMXLv3jD9tNNPx5O\/\n+EVsT3Kcvqg0kC8tidOGTuM2bcKuBIB+KILwUJBpu+ggUFUmk8+jmMnALxSAZcuMczab9plNjK+u\nfzTkJ5\/L4aXHH6+op\/Muq8rqvL6mbaeCaJHHgbkJouX0d265BVMvuwwjentZbzM3nZ3Ko66DYhVA\n03WlcC5sifmeRT3hfS4UCvjSl75UYStVqsFSCs2pBl0iTjmTyWDEiBGRAZ7CME2jFwpbjzJXFkuX\nosbz0NnQgIbOzopyNgO\/qayc\/txDD1W8nnfRaafhqSef1LZh6gNNt4XtgfKyunqpXdvaNXmysl4K\nwgMvG6iWy2xbvRrjvvzl0sNnMexzUGw63nUvHeEeLv3d008DFqEdOu8y7Y\/JYyzSuLqqPJpvgmgV\nQAPApE2bsGnSJGDZsvChQG5uZi5NNd4JL7EQBWgbr7NcRsQ9i+daMpkM2traUu9zqn2mFJpTDYrk\nOGXb8AuaL+fJMuVzy57nAeV6HaNHY0xXV4Utrq6cZgPKtM2nnnwSpy5aFMk7ddGicD5YTjbro5Mr\nULqA50ADsrLesmXwLF9yMhAa6nDu0r+4D9S5tE3P6UADhzb2THW4l46o1FV+QNG1HZ13WS4j\/9ZB\ntK0XmmsfqLxRUHmQ3\/vOdzDl0kuRVXiQbbzPKoCmQKwCaA7I\/\/6Tn4STuAcGEz6WU6WiSqE51YBK\nTBOXy+WUD\/GZYJmDPnrBMMGuCu48z4t4mbm6Ohs2oOyqpCDZpqxruaSnlItT9tj778fvXS+wCbQ7\nVDXvmGOqqm\/jOa5WGfKGTNUxqoJPqjiACwDHn3BCJL27vh6vPPqocj5mG6+3qj829uRyOoCmdbl8\nnRec8+4CwOTNm7F58mQUly4NQ2ZUYCvXNQE051GWAfnjn\/gEtxmqF7d9U5BOlaBSaE41IGptba2A\nZcA+VllelmU7nZyqfqQeE+PsAtuuoCzSn37qKZxy6qmRvFNOPbX0MgVDXVN6kpCcFPS7lksaXocr\nDMfVC7\/\/faL2koLqkTt39s+gIUEa1xYFN5t2TIBLgTlfU4OXf\/5z7QOTLuETXB909qr5N8DFC80B\ntPB6ZwoFjO7oQGdDQzgeymBM7ZsAWlXX93185KMftV7fRCVvqxSgU1WpFJpTJSoBy9lstsJrzAEx\nB8gusKyFYkOaqi0jbDPS2efEgfPJp5yCX\/3yl9p6cSHZpqzOa16tzbj5QGkmiGOOPbYqGwOpfd0+\nlW1\/kgrLsAHFbatXY+S\/\/VtVtgXoUdtx+\/X23LnGOnKbKnC17YMuptlUjquja4fmifUQee995zuY\nfMklAICGzs4SNJdvZHwCz6p11cU\/i\/of\/shHlOuhU1dtLXqzWWxsbAzTDn\/3XfRms\/1x8WQ9a8pv\ndwWAWul3RClAp6pSKTSnSkRtbW3wPC8Cy\/QDQJsmfgvpQFoH1bq0SN3yd7ZQqPCEm2yY8kzQ63ke\n9o4cibo9e5T1qvXEDoQ32dZm3LpO\/TDMwpBIG\/uxXMGs2nZGdHVhrwRBMsDYtqeDWp0t+cUv+Zoa\nZHt7sW31aitwks9ZDqBN3mddOQ6iTeXoOtvCvAzPsgrZLJDNwi8WEUj5Kq8y1ze5zbPPOUexBXjt\nHjECXbW12FyOLd94000V8dlBEOANadvTDwC87ytfieyfo7ZuVcNzqePCuFN\/Ux3YSqE5VVVqa2sL\nn2qWYZh7rbVY5iBZHoxdQjC4fA4GVIDg+37kgRjOpm2eDkK4fv3+pz9F88UX45A\/\/zlMO\/Gkk\/Cb\nX\/\/aybZrORdQjlsuKeAcCHDdn2D46HnzBsTuYAG1qj2XNkz7k7745Z1DD8XWO+5Q1nXxXruGb5jK\n2XjtaTnqRaa2VOmbbrsNk778ZWTyefiGWGXdDBpi+ayzz9b2HQB2jhqFd5qaAABv3Xwz3z8mHloG\nfnl95f5sWLkyUmcDoiA9s70dTd3dlZ1K4TmVg1JoThVLFJa5h\/roclKwrPI624BbpC7Thu0bAXVt\n2NQrNe9j6x134JATT3S27VpuoEE5CRAdKjaGcx9efOGFAW\/DFuyMUsQ10zZcIV3Xv3xNTVjG9qE+\nXTiEyvtM7cQBaK4vqn7R81s1t7Kqzuj2dnSNGYOAPBBIgZyDahMs92Wz2Dl6NLaOG4e3v\/3t\/gyF\n95q2K4eLqG4WaDnxW4B0sVgErr4ar48ZE5af1dGBpp4eSAZFJ7Trk+rAVgrNqZzEwTIXY6x7i5\/K\nW8yBXRKwrPQ+X3MNvGXLsLO5GeO3bEGNPIAivlfZVI\/WpWEaC088Ec\/85jdKG6b2dW1VY08uVy0Y\nJgbIgwioQwHITaqmjwMd47zr9ttR\/2\/\/ht3lv+Hj2nPpJ42Ff\/eww7BN4WU2QbQpf6ABmuarPMwA\n7xnm1kV4m0fu3VvaL0EAeJVvbuS8z2d+8IPK9QCA3XV1eHPKFLxzyy39tjTxz7R\/HDyL367w7Hke\nXr\/++vClKbOuvhobxozB+nKdhdu2yRsZ5U5o1y\/VgakUmlNZSYZl8VCfyqss\/1bBssvcyhwsq7zI\n9DdXjoPantpa1PT0GKdUiwvLurwXH38cC4m3ecHChRXgPJxBOWngHEx7mUxmwPqRFKgWamrQM3q0\ntq9V2S8UEulrbWdn\/wwaQOSmJ25cs229fE0Ntq1eXTFbhuphPF27tgAd1w4tp+sTB7Q0n8I8hWcx\nJaC4EVXdAJx+xhnK\/gIlr\/Kuhga89L3vyR039pdCvgqehQ0TPMuSwztEGQHQs66+GgDwTFMTD88p\nOKciSqE5lVYUluXp43SwrJrhwuWNfa6w7GIrkgfA1+Un6FVW2d5bX4+68uu8bdt2acfFnlwuLhQO\ntCf66HvvxYv\/+I\/av\/hlO0nAZNLb2LWsSZmengHzhmezWS3gyXkFzcNXmXw+OvWcpLgwrKrHeZlt\n69sCtAl6dUBL2zatr02fZLiUy6m2kdzHxi1bsKO5GfjmN4Frrqmos+i009h+9eVyWD9jBgDg3Vtv\nBQD4qARg2m8O6Kl3uRp4pmMzFxtN4fk3EyYAQD88p17nVEQpNKdiZYJlebC1mQ7OBZZdHu4zeag5\n+6Y8Vb9M\/THl6ey+9PjjWLBwYSRtwcKFePaZZ2K3Y2pTVSYOeA00JL\/4wgsVD71lMpnSTAjlUKEk\npTuuhooOP+KI8Hemtxf52lrnflb7wB0HZdls5WVFbmdvczMyZbDWzG1QFUTTF750jxpVmi3Dsr7c\npg6QXbzGAwHQJqCn5eRznIZoZMtQSS2qYBkA2hsasGnSJGz6zndK7aESyCkU036rblqSgGdOtJ7v\n+xF4DoKAh+cUnFMhheZURNXCss4z7DIThgl4VVBjGjRVsNk1ZgxGdXTEBmVVe1w5lZ595hnMX7BA\nW3+ogHK1EMmBlas8z0Oury\/yF7+r4rzhcCgCNABkFZ5mlxAAmzpx6ofQU1ODTLEY7rPstdciWLzY\nqi3Zg+0aKrL1kEOsvMNUHICqbNjal89jOrUataVrT5SzicXm+k7boCEaQRDg1EWLWNt9uRw2zJyJ\nTbfdpgRyHahz66UbX13gmdpXeZzlsuJa9\/r114czbgh4TsE5lawUmg9kMYPUedLve8pxaSpYVnmV\nXWBZ5XV2gWWTV1ALhlJeMZezr6doW1XONr+7vh4jpDCN+QsW4PnnnjO2YdsWLZM0hHNhEElApud5\neOeYYzA1xtvuqvGg29QbKhD96ksvsW+3i+Ox1cFwNfXbV60qhdQoyups60Js5HpHfeADkbwe4mWu\nZnvYxD+7eIxVr7c2tW+bx\/WHWxcBkY1btmBnczNOJi9eEurL5dDR0IA\/\/fCHpbpSnin0QqTLfaCA\nTdeHjlU28MzJBZ7fuOEGFIvFEJ4j8c4pOB\/wSqH5QFGMC\/tnPvvZirT7fvjDWCEYtOxAw7ItGLp4\no039NNm1KfPSE09ovc1JtJUEKA\/kw3Gq+qPfe4+vwEyTVW37QwWEB0JxoFGuq\/NmW4UV0PrEWxi3\nX5zyNTXYcsgh2uOVxmDbeuZpn6sNueDexKeyV02ctSgj923z7bej+eKLUdvTg5MffZSt2zFmDF58\n4AGlTVm6WGodtFN45uwkDc\/CFgfPM6+6Ksx7pqkJvZ6HEZMm4YTNm1N4PkCVQvP+roQv\/p\/8h38I\nfz\/wox+x8LuvYFllg5PKhmqeZpO9avPl9F0TJ2LUrl3I9vYCAI4\/4YQKb\/NAgq\/KeQgAACAASURB\nVLJcXg7PsWknjqqpH+6vKsIsBgqQbe26hhokLR30uNowAbmNN1ROs4VxoSOPOir8na+pwaYjjsCu\n1lYt4HBAHQSB9oFGuc+2wG8DtYCd9zlJeBbL8kuWZHWMGYPNkydj0223KT3Lsk0wZXTnAoVngJ+C\njtqh8KyKpVa1Sed\/5uCZhmvUBgF6ALQecggObW7G\/M2blW2k2j\/lfqVJNTzEeXSIejIZdNbUoCeT\nQW+M2QU+\/olP4GMf\/zj+7mMfg+d5FYAlD4I0X17mAJazpUuzgWuuT\/TTfPHFyjyTxzpOPtefV3\/8\nY3Qp5rK1bce230B\/PF8mkwk\/8lzcruukk2vf5Hpcv+O0LcfqJ9H\/ONs8rk2d\/ST7FnddTHZ83w9n\nqgltk3ANrr7YZzY3cQCwu7ERm6QHJeMcb9lsNvJsB52Tnto2pcXpi65d23Z0EmVOPOmkirzXDjsM\nrx12GF7+yU+w+fbbK\/ptalsuIy\/Ttrl9qruWULvyFKi0DM2Tz3tRVj6u6L72vNIMG3JeLYBDOzrw\nt7Fj0Tp7tnb7ptr\/lHqa9zcZBsmeTAa1ZQ\/KyxMnsoPZjJ07Q1uNu3fjpYMPxmHvvoua8oMinD76\nd38X\/n74oYek7pg90bq8OBckXTpnCwB6R4xAIZtFJp9XlnVpz7Y\/qjK7mpsxdsuWcPn4E07Ab59\/\n3qoNVZu6C69NfVNeEuXlOrSu8Ly72IkLfElug4HQnLlzq6rPrYPrA4OxPeTXXAPvm9+M2pZeXGES\n3a+inuxl3jl9eum7tZWtL8u03qK8aEd1Hsle4aS9z4A+fENnx9QGnSMeKAEzAGxZtQpQhFSIZZV9\nVR3P40MxaLoqjbNJ2+XqcGWE5P0qe5xF2hs33IAgCDDzqqvCunPb29Gey2Ht2rUoFos4\/\/zzK9pJ\ntf\/JC\/b1f4OpkpM0OPT4PjpyOaxvaIjcWW9YuVLpLVC9Clv8nn7FFXjf5s2oyee1AC306COPROzs\nK1hWDZqhli4N\/3Yc\/8472H7rrbFh2KY\/tjYOO+ccjBI3MEAEmlXrZOt9NW4Th7xqyrtsj7nz5iFD\nwPmVz32uv+6SJVVBetx813JJaPacOZHlv\/31r4m3oYutNcl4WZGgGQBwzTXK+raXqCPe\/34A\/WEZ\nHDCbZNuW7bZRhXiYQgdMMoWt2NjnYDmfy+HN2bOx+eCDSwnl\/cLZU4XeuPRJd6NEtzFX1tQHXR1V\nGZou5wtwlpd7PQ9v\/J\/\/g2KxmMLzAaDU07w\/iLlYvzB+fAmiPA\/rV6yI\/JUlRCFZNeWb+L3xppvw\nVnl52uWX46Bt21Df3a0E6HM+9CEAwGM\/\/ami2\/ZgbOslNZXn6ngkrxp4tKlr68HePm1aBJqPO\/54\n\/O63vwXA39jYaCC9yro6rpBuK1+2kRDc2m6TavufpL8iTl9cYmu58q6e6Uhdz9PGGdt4MmUJYAaA\n3tGjq\/6HIYmH9oBovLRsU9SrNiaZs22y4XlexZzwALB35Ei8O2MGCtlsf33yohPqHZbTbPrEpYl6\ndFv65N+HwfA8y8cbTRf137jhBsy48sqwzJ6RI4FvfQuZ\/\/gP+L6PtrY2AMB5552HVPufUmge7iqf\n4CLs4pmmphCWX7vuuooYwlKVKEDTPPrNwd5bN9+Mt8vL0y6\/HJ7nYc7GjcgxAH3W2WcD6IfnIQPL\nDAB119c7tWeT7wLLcrmtd9yB8WefHQHnOLC8r7zKrukm+3978UUcdvjhTnVt2htoSJbrcdBRjQq1\ntSjU1BiBxdQvm3q2\/bVuWwCP5WwRtkC7c\/p07GprC99KZ9snVbs62U4ZR22qbkhkGxxkqmxytmib\nQhwwd44diy1TpgDon685rG\/YB7Sf8nhHt4luu3I3IipQjgPPQknA85s33hiCc+Pevdg5ciRw7bUo\nfv3r4Xq3tbXB8zyce+65yr6kGn5KoXk4y\/NCWH6hsbE0mAChZzlDHnaSf3MPQqnKqmBTfL9zyy2l\nb8\/D0f\/0TxjX2amF5ycef5xtU5YLLJug1ORdlZd3kwfwBgOWdSBMvc3zjjkGL77wgtaerm9Jgayr\nfdc2VMeFpoJVGy75Sd08uJaxVaG2FoXaWvQxnlVVO64QpguTUAGb6iZB2abvA8uWaV9yooND2ctc\nqKkx1rPtl1zfJeZYF3JA+0QBLpPJVNQtFotW+42DQTktCIIKYM7nctg4Z04pdrlcfuJFF2n7zcGz\najupPPK6GwLhYab2VfBMIZvrF9dmtfAs1521fTs2TJgAf\/lyeIsXw\/f9MFyjra0NQRCkYRv7idLZ\nM4apespvVLt7xozQu+x5pZhl+Y1+FJK5p9BFurBB84REvuoDAC9973v4xUMPYdfo0cq+n\/nBD1a0\nI2T7hLqqfa6eyQbV+EsvNUKbqU1dv7gntDno8TwPO1palN5vU9s2\/XWGU0Udm+1hY9c0Q0IFFPl+\n6eN58JYtU7at6zM97uP0l54\/po\/pXDJ9ti5YgB3z5qH98MOxZ9o0p\/PBdR1dto9ubJA1esMGbV3b\nPnFld5X\/HufquLalqm8qazvLB9cPmiaP59XM4mECZrl8w\/bt2j5zv1V9EOtgO\/7KeVwdum257aHb\npqrjmDtu6bVQTt94002RtOm7dpXyli+PzEYkZmFpY47LVMNPKTQPU31v5ky0zZ6NQzs7w5NWADOF\nZXqxpmEZclk6QAjRsqploefvvRePP\/YY2hXwfMaZZ+L0M84Il10vBKo8rp7LYA2U3iCmUpyBXnWx\ns7mQe56HLYccEmnn6HnzrPvlmq6SCjJs94HKFndx0mnPhAnW\/VT1VQWuuv55nheZkk9cCMVv+aNK\nlz+5XK7iI9vXfd43axbGvvKKsm+69uUpBVUwZgv2um1o2uad0hv6dPvRVOZwaVq5Qk0NNkleZ1u7\ncc4D27Kmm0CbvqnGMW6fqezQFyZ119dXALOsTKHQb4M+tAm9M4Lm03Iu47GuDr1eDCY8i++NN90U\n\/s4WCpja0VFxzIvzLJvNYu3atSk8D3Ol0DzM1NbWhtbZs+H5Pua2t4cnJwVm+USn3wDvZRPiBieR\nxl0EuAFPlPntfffhiccfRx95RbXQ6Wec4RyKYQtq1hfI8hPinueV\/irW2Na1yQ2WLl5zVZkdLS3I\nEw+rrq7JZhKQYEpXHWe69bTR7qlTUaitZduT26T7QIZD1f7igFKGTwrMdB5fCq0qu6qPCrCpXQDI\ndXRgzCuvwPd9dN9zjxG06XZQ9ZtuM52tarzovu8jqKsz7nuXY7anHKYSB1CTOi905Tlvq6qsqj1T\nfe6YP2H+\/DA\/n8shn8vhvZkzsfWOO1hbW1atKsU1l8dDm7HWZplbF509m\/XnxtiBgGeuDyJdBue6\nfB5T2tvhL18e6Qs9p1J4Hr5KY5qHiURclL98OZp6ezG+p6c0qHmlydd99A+2YsBQ\/SUmvlV5sg3V\nMi2vK+f7Pn756KOYfMklmLB9Oybs2BHJX3TaaQCAJ3\/xC6Vdud+cVOuhS4vkKcDdpk0XT1LctN3j\nxmGM9Papo+fNw0svvhjbnkmxtqFDmy7bi5Yt1NQg09NTyqP2NDd\/NhdlXfuqb1W\/q5FNDG2uvR0N\nf\/wjehxeTMRNtyW+afymqq6qjGlKMJqX7e0t3aCW7QW+ry0v2uW2TaGmBrtmzED72rXwymVtHgKk\nNnVtqOq7PGTIbTvXGTTEsWqKnQZKM+4I5XM5vFWe33vrHXeEs5dwbckPA0JqT7VOpgcDdetI2za1\nJUuU8\/3Keb7Ftcg25pnKpowot\/GmmzD9iisQBAHq8nmM27MHO5cvD+P06fHoeaVY7HSO5+GnFJqH\ngVpbW+F5pTdUNfb0YGd9PSb09lZcvGVYFumqO3\/6myvDLcvpslSwLOu973wHmzwPky+5BHP\/9reK\n8otOOw1PPfkk25YtsCUNb6YbA5WX3MaOS19ff+QRzPzQhyLgbFPXBeDi2DDdrMQtr9vnOw87DPXv\nvINR77xT+mdAsuUtXw4sWVJhn\/snRQW\/unPDpr7N+gHJTDmXbW9Htvx8g8meDpgBfvYH02wf9KEo\nrg8cCAdBUJp2TrYpbXcO4CnEzD30UAAlYN585JEV7doCqlzWtC42dV3ruACpS7vHHndc+DtfU4O3\n584FggDb16yJzCyiemX12E2bsGvSJKv2OFCWy6rqmvaxabvI7apuJjig5vrHbWsdOIv2aR+CIMC4\nPXvQPmoUiuV88apuVV\/ShwWHj1JoHsJqLU\/OL\/7a6bv2Wuyqr8f4vXvDk1V+WQn9CKlgWSyr0m1B\nzwSWtJ1Nt90GfPnLmPbWWxi5d2+k3KmLFgFACM86KDUBmC3scWq++OIw3s821tq2Hde+CnVMnoyO\nyZMxrexh\/sDRR+MPL71k3W4S\/eTSbbazbR1TP8R2r+nsBKC4QaQgrTnmhXxSh9azTdet00C8LKQ4\nYgR7fKrK68DZ9ytnLdDZNXniOBiTYQfUsyzd8IjyNiAq4tw77rwzMue6agYF2j9ZLqCtqhvX8xwX\nnDlQ5IB5+5o1oqGIXfn4EXDneV7U22zRHy7d9maEg2CuPmdbyHWmDa4\/9Fjl7HB5nufhrZtvDqdf\nBQAPgF\/2Nsteb7lNsf1F31J4HvpKY5qHqGTvsoDmEUGATCaD8d3dITDL8co0HINCNBfTrPptA8dc\nWIIunkwuu+m22\/D8ww+jY8wYdv1PXbRIG+usAiJVGs3XqWvyZOW6iPSkgLka+E6qLAeEJgC0KaeL\nc6U25GNU9clkMmHdmo4OAMD71qwp5Xte\/0dqkzvmVbG83IN+qnT62ya2WfdgoCp+mXuoT6g4YgSC\nESOs7NI4bPpNY51Vsct0X3HrqdqXdJ28b3wDfiYTnQFFYZ\/amjN3bjiTSteUKewYqOs7ADZNday7\nyPac5urozifTmOZ5Ho497jg9MKNy\/JQlj3lZ+W2GS5dWtOfST26MUdV1HdNV9ej5T9dPtS6inm5Z\nlffWzTeH+Qft2FEC52XLIuORXE8+NuUZr9ra2rBG2mepho5ST\/MQU0tLSwQQwoF92TJ4vo+JXV0V\nFwVA7ylWDZJcelzQU6WpbIr0Fx94AEf8wz9gPDPF0cmnnIJfPv20s02duHzf94FvfKP0Om3PA3p7\n0TdiBFs3KVi26Sstt6OlBY0XXICeUaNQ29UV2x5X3ma72W5bXfy7rk3TxVTVzwovMblIqsqpLrZc\nmJOq76aLuU423lyqUeXZaIIyMAd1dRXbWxebbArR0H0H5Zt2VT+pZ5lKzg89nLJ3u1iMxKRzca60\nzffKgLjn7rvhK\/pjG79K8+U08e3yb4Go4+KpTiJcQ4gDZtf2xP4OggDwfeuXr3B5dHuo6sv9kstz\nNjj7QrpQDxomoSoD9O9zuQ4tT8t6Xmk2Dc\/3S559ZnyhXme6\/kDJeZZ6nYeWUk\/zEFJrayvrtZE9\nIg3lWOY3brhB602TwTouMNvcuavSOBhR2f3TD3+Ip558svQ6UqKTTzlF2V+dTV0+9UBx9dvLb8ey\ntS+XM6W52OK2Zbc0Jd5RH\/iAsl1Xu5zk49Bkj3px6DEol6H\/kMheFp2HcO\/3voexr7zC9pHzalL7\nOk+qbpYIzttc7ewZNl5lWg9ACMuoq0PfEUdYTTUX19Nss71M68\/t+9CmV3oJk+958KVjgPuIOrPI\nFIzccU2PXdU5qDsPuDydTd35YSvdGEf7RTXvmGPC3yZgpraozW1kSkBu7NT1RbcOprGcK8PtG906\nqWyorlM6u\/QaqrqmirJv3XxzmHfQ9u2A58ErO2To+SDbpOOiOIfa2trCUM1U+14pNA8RCWDmAMBb\ntgyeV5o8HeAHOnpxUQ06NF93wZB\/68CYptH6KruyfN\/H7x99FNuZeXg5cLaxKcSBh0t9mwuk7qLr\n0hatS8vvbG1Fh\/RwjqtN2wu+PKjr+sdtVxWQiH9PTGBMj2X66SBz8YqwDA\/li3r55QIUmDng48BX\nB7u6KddM66aqp9sOFEaDurrwkz\/ySHgPPmhl1waIbb7lbWK7XhxMh\/+kZTL9Hz\/qBOC2i6xCbS08\nr3QjpTv3qF1ajh7PJpCjwKM6V1X9MUkHi1w5oBKY3zn0UOxoaal6vFG1B1ROb6ezq7NnKqO6ptjY\n5trhbJquXfTY0F0\/Pc\/D29\/+NoBSiMu4PXtK4EyOR\/kY584lmp9OUTc0lELzPlZLSwva2tpYrxI9\nkQBUnHhymgo8hFQnvSw6eHADgm7AkdOpVOkycP35vvvw6qGHVsDzSSefjBNPOsnKps1gbuoTAHhS\nLJqrDZcBnsqmTXne5iOPOsrYP9v1cAUH3bGnAh5u2+ggjwNLWf7\/\/J\/wBZRpIFkFwly6HB6lAlru\nQkfLxYFk3SeoqwNGjkThyCOtynMXYe7bFpht4Ni2D2J\/hd5msu+4cUdO6y2HqujAWrXPVLbpsa07\nb7l2VW3QtkyyGU9FngmYbccd2\/ZU0jknTOOJTbu6bWrqq+66ZXNNU9nR7W+RNqarq3SclJ1f3Pio\nAmc6HqXgvO+VQvM+VGtrK+vp0p1UQHQydW6QF3lCIl9e1kGdaRAxXXyoTBceqs23344dEyZgB+N1\nFuAs26QDjNyuThX50pP7cS5uqjTbixZ3seG0s7UVexobrfpmgmXVRYMrwx2LHGxw+0EHiDqwUR13\neekB0rDNsseSepF1HlPuIuXSD5qmsqWy6wrVqKtD8aijnOqo9p\/rN01TtekC1vC8cNpA3\/Pgl8GC\naxsAps+YAaDkZe6aOjVynNrCszg2TeOVfByrxjwuz3T8qM4zrh+m8uLtoPmamhCYORuu45lpzLDJ\no2OBrg+67cuVs+2Tbl\/RMty2UrVFx0AuXQ7TmLhjB2tXNx5yy5lM6cUoLS0tym2UamCVQvM+kOxd\nli\/m2gsvgFz5wQGgEmRUgw49uTmIUg0WqgFGdeHgpBsAdYC4ZdUq\/Pn++7GXiXM+8aSTlB4Nuh6q\nPlWTL5fT1XOxYwPLss2O8gwfqnzbC5Sur3RA18EA9Q6q6nIePNUFjF4s5JtKGZpDCPb9yOwZFNbo\nOWULyqpzwvTRtWcLvBU3hEcf7VyH9iHutw6mTccE3ZYVdssfNo85XveOHw8A6Pn+9yuOW7rO3DHN\nHasqqY5Z3XHMnUPc9jGND7pzVAAzUHr50buHHQbP87CDABXXb9s2R+7c2Z8hzaChs8G1Qc9FU11X\n+7o+qcqqxiuuL7b7VmWrrq+vFEJW\/veSljPBMj3\/crlc6nXeR0qheZAlvMs6YI6ciEuXlk42w4Vb\n5AkJW\/Ky6gKiGyyoPZUNKt3Ap4Jdrv0XHnuMBef5CxYo6+pkMxjb2OC2g0s\/dLZ0ZWX1SA8EHnnU\nURX7i2vHtP\/ocai6sNDBnGuHHoOyVLDHXTRoewDQU\/Y4ClsZ2cvs+8j8139Zg6nqgmf6uJa3+bhC\ntUudasHZtozqGGP36Te+ET0eNG1NO\/hgACUv8+6DDmK3P21XB88m6KflVcc4XUfbsc2mXdq2WJaB\nOV9Tg\/bycw66OGa6Djp5nofta9Ygk88by+psqFTxjwNTV7U9dPmm8qZ0+biw6Qs3DsjLIrYZACbu\n2AHfi9400rr0vObOcVFPeJ1TDa7SKecGSWvK88lms1nrAVv+PXbPHnieh4033RSeeB75FjLBsird\npSzXrimd9k1VV67v+z5eeuIJzPnYx9C4bVuk7PwFC\/DsM89YtWvKV23Luq9+FXuvu05pw2W72LRn\nKi+0q60NOO88HPTCC8pyNuur+s31jzsuq63P5VNPjKpOccQI+N3dpfLXXBOJGSwbqqqPpvI6OwOi\nv\/97eNRL53Cs0ZeLxPm2KaMS9wa1IAjC8axY7mtA+ut50ZdS7C2HbfXdey88qKeLk9df7r9q6jGb\n8cPmhSj0RTG0P7Qu3R6cPdW2zdfU4N3DDgOAiIdZVV5ON+0vz\/Pgl19wwpU11bdtg3vBisgTcn0h\nSjVT4Yk0ur9V\/RHpZ59zjnI9I\/r4x7XZ9993X2QqO90x6\/s+1q1bh76+PlxwwQV27aeqSik0D4LW\nrFkTxlcCUU+rfOfIwQLKv0d1d1fkmaBXBcZcXRXM6myoyqtk8sCIb67cqz\/+MWZ\/7GNo3Lo1kj5\/\nwQI89+yzSrs2\/YpskyVLKibyj2PTpo4rMHPlOyZNQsOmTQCA9x95JP70xz86w7ItKJqOJVfb8rJs\nX+e5liWgOcwjH1ew1wH6oAMyJ8MNp0lJ9NkVsjnR+Y+DMgSEr3ZmIFccE4XaWuw56CDAAnJFW3Lf\nZRDSzd+sglcbGKbHSFEKq1PVk7ebqh+ijJhmEkAIzDtbWyvehqgDZ1MZoZrydSes5wCotmVoPh3\/\n6f7i1oXmxwVnaodC61lnn61cj6T095\/8pDLvnvJMMaJPxWIRQRCE4RrnnXfegPfvQFcKzQMo4V2u\nqamJXPhVXmZADb65YjECAiboVf3lRetyMKIqyy3b5KnakPPlGwaV3VcffBATvvQlzCLz9J4wf74W\nnHX9MpVxLW+bbgswuhsN4W0W0GxjVweSNseHC3xy5ehvHbCq4FmoMGYMsuVpGMsVwgu7ym41oLzP\nRb3M3\/9+LDNJr48NONN0YiCEWc8rhWhQAJrY3AwA6G5qCtN0gEnFgRBXTwXSHLyaPNxye6o8at8E\nczIwixl0djJz+NrcvNiU0dVTLavqiHVwzZfBVfVyGa5+EuB8xplnsvX3lT7z2c9Glu\/+7nfDbSPC\nNc4999x91LsDQyk0D5DWrFkTPsEvwzIQjecENBfs8oToJuCKG47h4l3m2rXJ0wEzFztmsrtt9WrA\nAZyrBea9jY0Yf+GF4V+fcbeBTTlaxhaA3543ryJMQ2WPs0lvWFTwbEozHZemNBNE0\/XpmTEDuc2b\n+8uQOEF861vwvvY1FpxNED0kVaWnmSqpdbUJbaDlIhAtxkVRTnFuCi+zB6Bw333wg8o3BJr6o\/Mu\ni3SbEAzT+tH2hA3aPtcfFejJU0uKsAwOmGl71YLzyJ07sWfcOLaeatnUJ9d8bvyg+ykOOMvlTzv9\ndGP\/TerLZrG7rg5jOzuVZXZLb5uVe1aTz6OmHA5jq3\/63OfC39+96y4AwJ133ol8Pp+GawyQUmge\nALW2tiKXy+kf8GMu5ELhcvl7TPmVyfJ77SPlFMtxysnfNF0lV2DmvMoukC7AeeK772K05Gmk4Fwt\nMNMyrsBczY2HLYDTtMOPOAKv\/OlPrD0V8Nrsd5Utro5NWVtQZr+lfL+7G6MbGrC7qwve4sXAtddG\nyzDnmu6htSEt2dPs4Bk0aTC3ARuWIB0LQRDAW74c3uLFES81APQ0NVXsSzn0gcZ+muBZBkY53TYE\nQ9RXgbC8Tipx8Mm1+f4jjwx\/52tq8N7hh4chKib7uvWwKZMrh0CpQkpUy7o+xQVnLozDFHes2qYA\nsOi004z9VWl3XR36slm8O3FipM13brklUk60O\/WyywAA3bkctowfH05xKvdr2uWXIwgCNLe3Y1R3\nN0b19Fj353Of\/3xkuc3303CNAVAKzQlq9erV4cwYOljmwFlIvpP2PR4+aDlbWDaVpX3hllX1TG1T\nr3ZcYBbavmYNvC99CXW7dyPb1xemC3C2salsQ4pr9jwPPaNHO4GFC\/Bq+2GR33HnnRhz7rnoGTUK\nteWbKx3k6wBVVYbm2RxvOnjmvM2qc4Ltb7n+iL\/8pdI+\/ReHwDl3\/g0bJexpphqs7VEBXxKkymAk\nfo+fMAHF2lrsPfjg8ME\/AbbiOREBzxSixTfNk4HZBrpcwgp0MGkLn9x2AiRgBtC+dq0VOAubdF1t\ny+T27u3vJ1NH7mtS4KyS7\/sV\/aPeZ3nfqvaDDSz35XLI9fVhTxmOe3M5bGtsxHvf+Q6Ayps0qROR\nRdqPEX19pe22bBmCxYsj21DM7bxRiuMWdadfcQWCIMCkjg6M7ukxAvV5558PnH9+ojfYqVJoTkwt\nLS2oqamp8C4DqFjmoEFO54BD\/q1b1qW7lKXt2ubJFyVd+IfOji1ECo\/z+8qeVaET5s\/H888952RT\n1Y7nedhdjqc09cd1e9necNjYLNTWAgSaqT3ddjetg2mf0X5TQDb1SQfzqu9A+pszbMf3K7zMHJgP\nO2AGBszTTDXo8Pwf\/wFcey0g2tWAHQB4Dz4YwrOwQ48zCk8iT36oTD5GTX\/1JwnOKhsqcJa9zAKY\nd5Xn6HWFTx2Q25TxyqCn638S4KzL4\/aXnAcgfEBOtnPqokXGPgFAe0MD3pPGfBmSaR+5mwyVB\/zd\nW2\/FlEsvDZfLP9jt5jM3km\/eeCMAYGPZ9owrr0QQBDjmnXf0KyTaSuE5EaXQXKVk73JcYI54l2XQ\n1ACyDnI4WB2s+GWX11bHAWYqFTib7NmAuVym\/oorsLs8aHF2XPqtK2uakk\/V7s7p0zFy+3YAwKGH\nHYa\/\/PnPRnCl7elu1HT9o8e7nE7btI7nJ9+RtAcfhPeJTyA\/axZyr78eLVN++UlY9v\/+X3j\/\/u+R\nMsMSmIEB9zRTDcZ2CkHE98OLuuf7oUezsfwSk74xY5QgRY+5YrFYAS4CoGQYkaFElS7apPHYnEyg\nLEO8LejKwCzmYm5fuzZy02ADwlxfVXXozYYqX5fuCvMu7QB6cBb5QP8bZE3aU1eHt6ZNAwBsuu22\n6H6DfqYRblo4Vbqw0bR9O7aOHw9v2TJACkWi21Acz3R\/+b6PN2+8sQTTKHmhZ2\/bhtE673MKz4ko\nfblJFWppaQlhmQNmeUJysQxEIUBO04UwyMtDEZh9X\/+mJ1o3LjBzZbatXo0NRxwRSTv+hBNiAXMI\nVtdcE0lXeZttIMxmvbn9rxIN+elct05ZhkKqqt8220plg8KoaFd146irT\/vNhTfJeRW2\/v3fS3mZ\nDLxMBr40Lzp98HRY6aKLSp7mTKYEmIMI0Nx+0u171w\/Q\/w8BPI9dt92zZ1v3l07jyR2b3PGvinVX\nrSPdRtVKZ7N90iR0lKGZy7cZh1Rt6OrtaGlBX12d9frajCk2dmzydXkn5qxAoAAAIABJREFUnnSS\nFpj7cjm0NzTgr3Pm4K9z5uD5hx\/Gpttuw6bbbmNtc8cszVc5FDhbtT097DnDta37B1osv3njjXjs\nrrtw7w9+gN9NmaJc73LF\/k8qZ6We5hhavXp15I1G3AVdd1ER36pBmP7Okb8YaRmhwQZmpYfcUDfu\nBUZXj\/M4H3f88fjt889b2Ygz2LtcFEztJmFLjmsG9Pue+21bTjfY2xzTqrZ0tiq+if2IpzuT6Y9l\n9vtfzzysJW5IhZeofHEfTCUBhioF5f0UFIsVnrBibW1\/Hx58UBv\/TPur8sZSTyUtx\/ZR433l8kxx\ntZzk\/MPLjoCeUaNCYG4nb4DTraOLbOqGZSxsJelxtmlHyATKe0eOxKbytqQeZRv7Ik21XqZQn3du\nuQVTL7usYiwT+Sr7wq4YF7kXwAi9ccMNeL1cd8aVV+K4995TriM8L\/U8OyqFZkcJYJY9V5xXLSlg\nVsGKLFcArgaYXcBcZ8elbRfbOydOxLgtW8I0GZyrbXv0ZZeh69ZbrevowDouuHL7XmjbnDmY+vvf\nAwDmzJ2L1159VWvP9obKBMk60DWtn6p92peKc0jhtQYAL5tlywxrZTJD5uLmuj91sBlKhGeU\/9KW\noaEoxa67SgYWuQ8iDlr1Fz\/XZxlWZNtcXVW+bZjHYeXYZQDYOns2EAQVwCyXdwFnHcjSbQQAxWzW\nWEZlxzUcxbW\/Yh+qYFmA8ubJkxEEAbasWtVfF\/oXp9D1oP2JC85CkzdvLsVOL10KT5pJQ7Yv15HD\nPeQ2aHmRViwW8cYNN2BDsYj3feUroZ2jtm5FbaEgdw7lhthtkCqq\/eiqMvAScy+LUAQTMMt\/E9I0\nmi\/KUDsAkC0f4Bw0qf5y1oGxKzDLNwlUNsCsgn2btm3L+L6P7WvWYNfEidgpTQEElMBZZVMHoWJK\nIKHe0aOd+uuy\/XXl6PHA9XX3d79rZZP7bWoXQOQm0eajWldb4FLVlc8bLjzDL3ssvWy2BGLZLHDT\nTVZtDmn5fn94hiEMarBkeyxwx3HFRzzAKY1n4xobAQCdUlwv1web36pzSdUfVSiRKdxJNa6bto1K\n4gUmtueNa1mdjfDcV8wdzG0nnR1dGZv+cFqwcCELzH25HDrGjMEbs2bhjw89hK133FH6N5JIjGsu\noYXysqpfulANMSVdplDQHqdc23RMpuXlfSJ\/b1i5Eq9ffz0A4A9NTegoH1ekg+y6pIoqhWZLtba2\nhq\/CtgVmLl1Ok8Ud\/KqTSChO6IUqnbNtGkxcBrtqBnKXQVeAc3d9faQMBWeni1D509vQYFe+ym2v\nGjBtyuwpPzhVjU163KniirnYUZv1srmQ2vRVzou0\/5Wv9AOz+B7ukoF5iHnQnQFZ9ZFDalasANAf\nmuF5HvDAA\/2\/Y\/bRtMzBLy3HnQ\/Ujgtc03LCy5yvqcGmcohGx513GtdPlsu\/fya7Yso5lWyeFUj6\neYIFCxdiwcKFFekcLNN+qKRzDnEyXdtsrgMTtm1jjy9aVgfXXBkOnAHg9euvx4aVK\/HXxkY819yM\nHnp997wUng3aD64mA6uWlpYKSNA9XAKoX9ygOsm4PLlMTv4rpSzVnSxnn7bB1eHs6gY5F\/DRyQWI\nVXm0zPY1a4ALL8S0v\/41MoezrT1d2dGXXoqu8hREuvo2kBrXhs72rhkzwlk0Dpk9G6+9+qo1MHPH\nIb3YqbxoqnUwtWkjbbm6OoC7qMtwuT9cBIZQeIZKpv2pDdPw\/dJUc3Rcq2LfeZ45zln0h5vujZMp\n9tlkx1T\/0MMOC38LYO5ct6504870VRZdX115btvoJHqrqiGvT9zp7Ix98DzMX7CAzZPDMCgoU+nC\ncsR2obOvyHm0vJAqTzVVXRAEKJShldpWhV9wM7twktdBXhZx0RtWrizVLYdtzJdCGssNiIqs\/QNZ\nQ8tlMcTU2tqqBWaap7tL1N0x6oDZ8zxkCDQnBcyyPXqHnSQQVwtNcWxvX7MGb82di3wuF6Yde9xx\n1rZDu\/IsGgbgtE23sWGzzejvPXffDQDoKYeRmMrLv+lffdSTrCoTF5ht843lRo7k032\/38ucyQDM\nX7PDTp43LDxB8rhGP8r8r3wlEprR8J\/\/CQDIl6ea49ow\/VbVMfXFZj1sy7q2IZRn\/j7X2dGtv8s4\nZLSlSHdtT3Xt04kDZuFZfvOQQ\/DKI4+wIRiq9m3y6LVRNy67bnvPK82iAaAU10zKcddjbnxVHXOy\nHXlMl+ttWLkSnufh2YkTsZV7dmCIjzX7Qik0K9Ta2goAFcBsiusE7A5kmqYaUAGgR356XDNQupy0\nIvRCB+Aq2Q6KNrZsbNimUwlwlkM1jjn2WG17rG0JVLrKc3nqyrtepLiLqE057jcAbJ8zR1tXTlOB\nMD1uufh8aotLM5XRpcctB6AEymK\/DaE44EQ0jLw\/NuAZfkQ8ujQmdR96aCnvwQcTAT\/dOaQDUlPf\nq7EjNPfQQwFEwzK67rrL+vqiWmebbeGqOOdr3PF8\/oIFFcCsguWkxhLVNVMXuuEyvr1bfqA8q3hg\nUG5Ttd85+yrekMM0qJNvw8qVWL9iBTY0NOCZpiZ0SI6msiHlOh+ISqGZUVtbGzzPi0wpZzNDBndQ\nmwZWeVmWvCz\/haMqZ3uyUg+iq1zAxXVQSrJtuY1N73tfJJ0DZxe7484\/v6oLjqpd2+1lU6dQ9lTN\nOuQQ9pjRDcZyuuq4V\/VNlWZ7IbNRpFxdHV\/ooov6B\/thBJmsrr66tA7iM8xkGhcjHwmaiyNGGAFR\nboP7bZLq3xIToOjGfLmsKm5ZTvN9H3Pmzg3zBDDvuftuJQSZpNtOAzF2mdp0tSVEYTmfy2H94Ydr\nPcsu40icbaGLfXYBZyHuoVO6bPI6684t2g4NLxXrsn7FCniehz+PG4dnmproCrB9PxCVxjQTtZVf\nT8p5l4HoAfmPn\/pUIm0++sgj4W\/uxNrV2Ij6vXurAmaXWOU4ebq249qppo4ov6OlBeMvvBBvHHkk\nZrz8srKc1v6SJcDSpVb9iLuNbC9yujq2feO+6fER93ipFqBdwTk4+mh4b7\/NFxKA6XnDEjZZBQGw\ncuW+7oWz6H5l45vLyyO\/9jUAwJ6FC8NYWnrRdpnKjJbj6sl9MU0ZR+uoYrW5aeBMfebCMnQS9lTr\nZBv\/rLNv075tP3WS43i5UIzOsWOxpfziju1r1mjPaV3csm3fbPsMmGOfRTrAx3P7vo8iKcu9YdAU\n5yxLNW2deGOmPN2eWI\/1K1YgCAIc8tWv4pmmJszq6ECTCCHZn8bRKpRCsyQVMH\/2n\/5pQNs950Mf\nUuY9duqpbLotMJvuYl3zbAbRJDwZNkBpqie0o6UFjRdcgO76eozYvRtAydv8QnlOY1e73YYZKlzB\n2tZDY7NN9n7ve6j77GdZWzrPhDxwxvFsmfpr6reur5ys5v4tFSw9YOZ5QEsLcMEF5jpDTfvhhUp3\nsQeAwrhx\/WDw4IPsNog7F7GpLAc3SUEx194h5bcdymEZ4vkEWscFBlXrIud5nmdlr37zZu1bUVVt\nuJbzPA8nzJ8fScvncnizvI1sY5YBN3B2Fd2H8nVWQKmYU5nWA6LbYOyOHdjV2Ahv2TIEixcr2xDt\ncC82oS+TUd3QyceQCpyDIMBr112HQ776VaxvaEDT1q3yCghDNptpv1QanlGWDMy+7+MLX\/wiPvf5\nzw84MJt01lNP4aynnsLh69fjg2edBcAOmLm\/j+LCrAtEJQHMceyZQGtHS0tFmMa8Y46J1Zfu8eMx\n9rzznOpSG+K3DTC7eKWF5IcB6T8lYspECs50WcgWPmwvmtWIuxApddFF0eUBuoAOmoZpeAagPzbC\nPGn9eo89NnJM6j5CLg6BuDd4rjfwtrNyAGCBuVqHgZynGzeSdnTEKXP8CSckBsxCrtPH2abr8mjc\nsKqeiGsWDwNy5bn6phmM6Jgu\/6bONNlBKPfd9328dt118DyvMlSjZJBd9wNBqacZpWnlstksvnju\nubFt9Crmgu3LZrFh0iQctG0bavJ55PJ51Cgmi7eRAGehnz3xRPhbPvipXL2ftvVkJTU3qG3bcTyi\nNExj3jHHGD3OnueVQjSWLQvT8iSWNinvMs1zgQI5X556bsbMmXjzjTfYci7gkaRU7dh6\/CJpuoaE\nl9n3h+9AP0xBWUjsK3mfqSB6RDk0QyWb40YuW82b6FzfZid7+WzrzDrkEAD9zyDEUTVedZs8z\/Os\nz504nnagBMyybGDZdr1t11m3\/nHCXOTQDerxlr288uxYqjFPNW0d9TpzHmfxm3qghTecep5ljnjt\nuutKDV59NRbIHudSI8N+bIqjFJo9Dxc4VnmRzKCwsfzGMQqN8vLbTL78Dvqp5QOyfu9e7K6rw9jO\nTqu+nHHmmeHvJ3\/xi7BPsqr1MNvY2BceZtsyotzO1laMO\/\/8SJiGrR0qOouGSz+TBGYOenu+\/33U\nfvrTxnK6ZVtZh0lo6lUDyjKQsf0IgtLgLuB5uGqYXpwoMKvAORBhNJb2hOR9bgJWzvNrghMdRMWB\nclXdTe9\/PzyUvcyK2ORq2qX2APW6cXmq0AyVfRdw1gGzKXY5yT65lHNtmwsVMTm4TGOgsCGDMwVp\nVQgR\/a0D5yAIsH7FihScyzpwodniAtpbnrWis7YWGxsb8eaNN0YGafmg1wGzCkjE3zMA8I5UFigB\nNQBM2bIF9Xv3ImfhnV502mkAgKeefDLStklcGRcQSrKsrS1XYBba2doKnH9+xNt89Lx5ePGFF5zb\nGXXJJdh9223W\/TRBMJevOnY4LzstW6ipQaa3l7Vn2n5xYVhng7PJlZH765pW0Wc5phkAVq2qDNsY\n6hqmFyUVMGvBGUAwYkR\/+gMP2IV2KGQDxq5ygS9deyovs6mPKs9jHM844AbPtrLpBwfLG+fMQRAE\nJVh2sGXTl2rAOa63WeQDyTw0yJWn8dNc3LMKllXgzNkS4Hz4rl1okF8adoCB84EHzRoQEK+U3D5y\nJN4bPRpv3HBD5I4rSWA2gZAA6nfLk55PKc8QMGXzZow0QPSpixaFv59+6illOVM\/dGW4PlerpIFZ\nJQ6crWxIs2gAQF71Yg2mrsvNgg1c0zLcbBc9o0eHIRpC1GNF022kK2uyqxqwVcvy+ug8zZ7vI+A8\nlZdeCtx6a2lQTzh8aNA0jC9ITuAs8sqhTya4TkIcVKughvahmn68b9as8Pem978fQOkhXtO+Tsrb\nLGTjnZfbdZGuznHHHx9Z7hw7FlunTgVQev5E5W2vVgPlcXbxrlN49jwP47duxfamptL1ZcmSMB2w\nA2eaRj3bdMw3gTNlHQrOszo70dTdLXdgWI9TLjpwoNkCCP7Y3IwNK1dWBMmXqlcCMwfESQAzl95b\nW4uanh688MADAIDmiy9G044dIUDnyOuihU6RZt8wAbSufZuy1cgEii5t2vZLjm\/WeZvZNgD0GGbR\n0PVHDFS6slyeyhvNSY5rnnbwwXhr40bF2kT75KpqAJyro4LlyHI5LfPaaxEbcrlQwtM8HB8EvOKK\n6PIwuTDJUGkLziPKsFCU3kxmA846oHYFLVV5G2i3BXv5+FTFMlfjIY8LuIC633GhldYLgiACzMK7\nLCR7mG36kATM67y9LvvAxhstl5FZYURvr3L9hEx94TzO8jLnLJFty+DM2RYwLcB5\/ejRleEaB4CG\nqevFUQbv8m8nT8b377knBGbhuasGmGk9mzQb0Gi++GIAwJZVq\/CnH\/4Qzz\/8MNbPmIG\/zJ6N9oYG\nbd1TTj01AtGu3lC53EABs205VR1bWzvLb3zcNXFimHb0vHlm+0DkwbP6Sy7Rtu9yA8CtnwzXLtu8\n7957lW1y0MIt2+aZpGuHeuxMfarox969xvYQlEM0isVhA52hxA2CdKMwnOQCzkK9hx9eSj\/55Ioy\nLt5nV8jkbrpsvMv0BoH7LWumNItPxMuM6sZgOn7EGaN19UwvxdIBo6inAuYdLS1aYJZtJaE41xyb\neq4On8233x7Jd71e2DhWdC9GodcWmX3oR2aj9StWAEB0Zo0EmWAoa\/+HZsWO7Mlk8PykSfjRXXfh\n9euvB4CKg6VUPR4w276eWgfM4gD1fR87J01S2tmyahW2rFqFlx58EH+ZPRvbGhvZdRai8Kxqn1OS\nsGxrj9veSf1Fu6u5OfKabV2fPM8DrrlGTsBuxQOBLgOgyoMsZIJcHXjKU88lKVe4tQF0V7gOggCe\nBM3Kv8wFLAt4vuUWxVoNcQUBUH7oeChLdTy6gDNnM+5vlR2ur1x6UrBM0zkvs42H2tXrHEe6MTcO\nkB9z7LE49rjjwmUKzNSuK3zGUdLXMlu7upsS1RsqdXVtYNoEzrSeCpxlgD5QwXn\/hWbPY3dgTyaD\n55qbcf+6dXj9+usr7qKGCjCLV3ViyZIwv1f621KlLatW4c\/334+nn3oKf50zB3tUrxkGcPIpp+Dk\nU04Z8sBcjT3dxUV4m+X5m2VvM7UdsSW1Nebcc40Dm5xnKpvUDQEAbJf++pRt23ibkwbjuG25esQr\noOWKK6Ke5uEUprEfeJnl3zbgHKZZ7ieX44MrZ3Ps6W7aXWCdi2Xuvuceazsmqa4zcceZJOD1mGOP\njSxzwOxqV5Sp9uYhzjWomuuWzU3BYIEzhWRqi\/7rrgPnZydODJ8J29\/Bef+EZg0s33fnnRFYVoFy\nXGC2OaBV7Qh7GXHwkfxCNut0Am9ZtQq\/e\/RR\/HXOHG3oxkknn4yTyn+FqpQEMHN3tJxUFyob264S\n4Cx7mz9w9NF625K32fO8yAOBOi8Qd+F19bKp8mzAYdrBB1u1RT86u0l7mHVe88hyOba\/OG6cXVsy\nfA4nAB1m\/abHjS0415XPoaDsGNDVp79p+7q+yX1U9T1OGdvyQrKXuVgsxrbDSQdssT3PmrZ0Nikw\nd44di41z5mBna2s49qrsGvvksC42Hvyk2rIVt+1kYJU5gPahGnCmdkzgLNfjwFlc814cPx4duZww\nYN4Aw1T7HzSTndWTyeDZiRPx0oQJkZhlDph1s2TYArML1NJ2TDFjnRMmGG1zaVtWrcIffvxj\/HXO\nnJL3WTHrgwqekxwwkrSVpEeWvi0QqC7EwkUmkJSXbaBASMQ1m16coIP3IAgq5hcdKA+za70gCFAo\nT9vF9Tsi4WkWn+GiYhEoFPo\/w0gu4Cy058QTSz9OOskJnE1jgenmUk7nXr2sAlsXuJ4lHasibErE\nMrvYsRkLkvAQ037oanE2KTDvbGrC1qlTI7BcbT+Tup7YvJjL9t9EUxmXPtM3+5rq2oCzrgz3LJcK\nnMXyhpUrw7J\/Hjduvwfn\/QuamZ304vjxWL9iRWTHJgHMcQ5Orqx8UtjWFw8DukrEPr89bRr+Nncu\nOsaMYcvJ4LyvgDnJsqYLqo23mbYXGUABjP7CFyx6Gr+PcWyIZRrXrLsImy7etp7tpMFaB0hFEsPP\nlqUe2\/JzDENehcKwgX35GNHBsSqvMHassaztb1W\/VHn0Ny3j2p6uTKGmBjunT3ey45Jnkz\/QkoE5\nn8vh9fe\/HzsnTtR6l2W59L\/a8d\/WDi2TFDjrrvs6TqjmGqlz+Knal\/tBIXvDypVhnQg474faf6CZ\nOYCenTgR61esYL3LdMeXTPDAXNmUOS7VdLLQO0htfSau2aVNqi2rVmHrHXfg5Z\/8BH+bO5ctYxOy\n4SLxF85AlK1WnudhV1sbNkvxhkaJuTQB7GHCHmz7b+tpdQFWql0zZlSU5Wzo4JnrS1JgbOuJVi3n\ny0\/kqwAoCALgq1\/t99bm80MeQEPJXuYh7Gm2AWYTDHcfc0x\/ujTTiQs4q\/rFpQuPsurcouskl+G8\n0ToAV3mZXccJm\/KqdY4rV1sUmN8qX2NsgTmOknLu2ILwQDmAAADldzNwotBqG6bBpeuevdKFanD8\nRMH5lfIN8P7obd4\/oNkRmE1wrLujU50wNnegnuchk8lUxCrp6pjyXMpwZbfecQd+9ctfYrtizuGF\nJ56IheIv05hty\/lJe0CqtUf7Jnubj\/rAB5RlqfrGjDF6m20uZtWuj8tFVed5o0ChK6tbLxeQ1oG6\nbpmCivgrXf5dLBYRFIsIhOfW4g2bQ0Kyl3mIQjMHl\/I+EGXkb\/n3yPp65CdPjpYJgsiDgK7gbHPc\ncvVMtm2Pc1Ua9TLHUZybhKSkGgGDoDQ1Zhxgjnvto+vJlY2zLWyvpdWE5NF2XLcBF\/Osq2PjnVaF\nZdA0lePR9\/0QnD3Pi86qsR9p+ENzDGB28TDbeJRtDv5sNqs8yG3DMoDSS06qkcq7\/Zcf\/UgbsqED\nZ93A5DqoDNQdPDfA0v3Wvnat0tvMtlX2NgNA9+TJsfuiy3f1zppsHzx9eoXHTAcC8kWYghBXnvPA\nceVMaSaPnwzD2T\/+sWJ9isViFJiDAMVCAUGxWPoOAgT\/+38boX+f6txzo17mIeYd5\/aL6iPKy9+y\nug89tD9v\/vzw5oY7F3SAzAG7XE7OswHtogHcdduFqlBTE5mX2eVm06bdJMu4SNibd8wxYVp3fX1s\nD7MNDKuUpMc5aWeVSmKu5gby9lYb25lMBtms3TvqVPDNldGBs\/ytinMW+c80Ne133ubhDc0aYC5l\nm4FZlg0w294dCpkOahMw0+U95b89Jl50kVM\/bMptW70af3zoIfxt7lz2YUEbr7NNe6pBm5ZPEsZ1\ndenym0cdFf4W3mblxU363TNhQsTbbPII6crFvWgC0Qt97w9+oGyfAg29iKvAVVWeK8uBim07FIJV\nMCxecGIs+9\/\/ez845\/Mo5vMVbXF93WcqFoGXXip9fvWr0meIyLTNbMFZfNe8\/nq\/7fK\/AsVCAcE3\nv6n+5yAIUBA3QOVPoVAI+8R9XPZp3H1P64nQjLzhgVwbe7o+xb1htSlft2mTNl8G5nwuh\/dmzgTQ\nD8yDeR6J8dy1zbghj\/vK2yyLYwwbJx\/gBs60DgfOYnYykb+\/gfPwhmYiGZjpHY8KmLm7J\/k7TpqQ\n7u8Trrz2xFiyRPv0skkuIRTbVq\/Gi489hlcPPRR9TEA\/B87VeAdcy7vAta4uN4C0r10LABUvPLFp\nr3fCBBQdHoCo9kKi8pQB0af9gegMGhRkuL\/STUCsWtatF22DwpAAIA5+ufLiO7NzZ4VNXYiGAOdA\nAVSm5UFToQAcfnjpc8IJwIYNg9e2RhwQ28AzzZePUa+7O3I80hsfDobp8UIB2ubGjfadrp+8zvI3\n3R5COnDdVp6bWMyYodu+AyFb+Oa0l3m5lgqY43iYXa5PSdhLylZ4\/CYAzhkmZMzFLvdvti04m8I5\nbCZKUDko97dQjeELzWQnq4BZvgsSy\/0meKi2CcnQlZPjllUHfTV3sAXprjKJO2FV\/rbVq\/HGrFks\nPOu8zjZ9inthiDs4cfV0F0A5TIPGNkfqSiEaALCbhHeY1tPmYmyCVK4evfCr3gzIeQJtIEAF2RyM\nyNBDIYUCCy0vwxJXl\/aVQrIyRMPC00yBmluXAdUQfAhQtX\/lbUMBl6bJv0cxM7uobmi4+vJxEheY\nbcrG1SzbKRE129umvEsfXdt2qV\/tQ3862\/IYPqg3r0jmOmtSTXe3NW\/oRJ+bsgFnHUjbOhRlG\/K7\nMET+b\/YTcB6e0Ex27jNNTXjtuusA8IHqcYE52qQ6nwIzl25eJfswDZ0X1FWmPm5bvTqE5+1knmgg\n6nUeCBCudoCPo11tbaXv5uZYbdRfcIFTe659VwErV87mL1uurA6kOYhXwQiVyqPHgY8KlgSEBUGA\nnPy3PqnDgnM+j2JfH4JCAUGhgOL\/+l9GzzKXVigUkM\/nw48M0okdi0MEmuX9I384MOY+3M2T6vjo\nu\/de5AsFFBTeZe6fBN3HBZhVx7iQCah1+1380yN7meOc93Hy5Pxqj01aW\/Yyv16O16bAnPQYblMu\nCIJEvc2A3T+cSbfpaj9p552JkziAFpxFwdn3\/f0iTGN4QnNZv5kwAc80NbGQbBufrANm2zssQP8m\nPyqnsAwmf\/fYsShks1bzNbv0g0oeFLatXo0dEybg1fIDO7JkcB7MsAwq28HURkEQoF2CZp23OViy\nJHIxKZB4cNt+cYCrutipLtoqeJannZsxc6ayTxRmdPAsp6mAgoKTDGBc2IPO28vlZXftCvtCvdOs\nR\/JrX0OxUEAhn0chn0eRlKF1ZCimy3Idkd7X1xf55tbT9oNi9IUs3LZQfXQQS\/ts81HBsC1Aq+wI\n+eXwjCAIAOkjZtBQHdeqPF06zbOBadP+424CZC\/zbml2It2NFQfhVYNujPpyHS7kLAiCCDDvnDgR\nQL\/DIU7bSYzvrjZdy8f1OFd7nTP9+62rn8lkjK\/mFssmTzfHS7IzUp7PmdbprK3dL8I07B67HEoq\n76gnJk1CfaEAz\/PYmTIA\/uUkrsDMLesOGq6ubZ6xzDXXAN\/8JoBSiEbW4H2qth9A9I592+rVpcQv\nfQkz1q9Hrq8vLCfA+Znf\/Cbxu+0gCKze2ORiz9TH9rVrMfa889BdX48Ru3db2QoAeCjNpDH6C19A\n57p1Tm0CJWhUrau4aKg8HmE\/mHI66NB5UDzPqygn4F5Vj1tXapNrXz4f5Ty5D3J6JggiNyuqflWc\n5+VxI1Q+b32hk\/uiKkfbM\/2LpRI9vwuK893Wy2iSDWRyECmnu3hfZeXLs\/YUCSQHQAU4m27iTNLB\naBwAt\/k3p7M8u47tPz9JtR9nX1TYL4cDyrVlYO4aOxa7Jk7Erra22O25HMPcOZiUbOzatF9tH1Xj\njDz+udoX1xV5HFGNxaq2VdcU3\/fD41D8FlPQzbzqKnieh4beXrw2fjz6Jk3CKYoHS4eDhhc0l3fY\nA1OmYGJfXwjMHADrLlouwKy7+9I9UMh33\/0OVJW\/q7kZzRs3YuJFF2HLqlXOdqvRttWrgS99CY3b\ntmH8tm2RvAULF1qBs+udty10qspxJ7zJbhAE2DxrFqb\/4Q8ASt7ml8u\/K7RkCbB0aQjO1YiCMzeg\n6QYxWq77nnsw4jOfqVg3HWRTm7YgzOWpbIp15IBYBc\/itwCmfEMz2G0yAAAgAElEQVQDcu3tAIC8\nBL+qcz4IAnj0okFglLtwmG6qdWmqMcQkj\/SrT7pJ1ckFHOOU03lZdV5UnXrK\/4QEQaV3mbOt+o6z\nPqo8GwC0WV8RmrH7u9917ldScFgtwMopR8+bF\/7urq\/H1oMOqqg3UFAr5AKNtmWT7nMcsPWAihAY\nodNOP11Z72dPPKFtW17OZDIVN+C68hV9JNceeTyXHReijPx7amcnNo4di7a2Npx33nnK9RnKGl7Q\nDGD1zJk4rLMzEhsjX5S4uZlpmWqAWaS5ej5dLrK6fCkThWw21hO3rhdwDpgEOO+YMAGz\/\/KXSN6C\nhQvx7DPPxLat6mu14Oyq9rVrMebccytsm\/oVoPSXZlxvs9yO3JbKy6ACVlquUFODTG+vcl3oQBgH\nhLl2Vf0UA7cKiFVeDZGeAbBn2jTUvfUWgEqPm\/J8l+A6AID\/\/E9411xj7K9KNuc2HUtsLqaZmNAs\nKwmY1JWjAO0Cz5OnTAFQ8jKLfVcsRt8EGAQBoIDlfQ3MurzZ5ZkygFJohmp72NjWlbHxMlcLzF3T\npoW\/j7733vC3PLXcrra2cL+5yjR2JAGzcQB2MGyeumhRZPnQV18t\/Xj8cSc7Z5x5pnXZxx97DJlM\nJrzhlaGW+xaSl03gLOe\/fv31mHnVVQiCACMLBXi+D3\/5crQBwxKchw0092SzWFcGZnEBksMyAD6O\nRl4Wv4VM3iNuWfc2vyRATdV2qGuuAZYuBQD0jRiBTFeXk80k+6gL15i\/YAEAsPDMwZgLTCYFzra2\nusaNw6jytGZHfeAD+MNLL7FQJ1sqjBwJv+wBrbb\/JrgNAj58hbbVM3o0RpIJ9Kl9DhZMFwcdtMtp\ndACm6yDX0d0YqPpSoGEXpI+h7a9\/PQxzCss7hjrFuQl2Ud1nPwuKQ7J3qJqLtStkmsqrwNlWnUce\nCQQB9tx9d38Mt2xb43m2XZ844KvKc4XRzsmT0bVuXQVUxu2TjZIC5jHnnotd5RsACsxipoyBDMvQ\nSTUumTykSfbDZmwU+RSQ95U+eNZZbPojDz8c\/jaBs+paBETDMwRAy3WndnbinVGjAN9Ha2srzj\/\/\n\/AFZz4HSsIHmuw4+GNP37kV3Lle6W\/H4B\/\/ojBkcMKs8yKZll9dWmvJ0abYX2o4JEzCiqysSouHa\nD1upYM\/zPGxfswa48EI2XGP+ggURcFb1gbPvUtZGKu+pzlb72rXAueeG0KyrGyxeDG\/ZMgDA3smT\nkWtvr\/A2u\/Rf5W2ld\/yAOhZaHvB2Tp\/OQjNXlktXwbEqX\/aC6bzWpn9tTPBcrK2F39MTek5Ubcpp\nXtmjWaivR2b37opQCFN922VVmkncvlDNOFGNXRfYcYFnWxVraysBz8F7GhfWuDo2Hk4TjNL0jvLr\nwV1BstobgYEUBWZZ1QKzq5c5CW+va31anuvDyaecUlWf9oU+9OEPR5Yf+slPAOhDN0weZ\/H9xg03\nYMaVVwIARubzgMRtLS0tuMBxxql9qWEDzU29vXi3oQFzdu2C53nYsHJlhUeZm4A7LjDTNN0rsF0v\nilVfWMvxswDQO2IEarq7jTbowZ20BDhz4RoCnJPy\/NqWtbWne\/hOSH4gUHibTW0Uczn4fX1VbXcT\n6MuDl7ir17UlQjS4dTZdPGSvgaqvQlyfOW+ysCuWuQsSZ0dOL5Shmf5VrfJ4A4AvHlrp6kJ2yxbk\nPvMZ7Ln77sp\/DxyPsaTOsdrf\/S6yvONvfws9rknIFhZpnmobm9JU6hszpv\/mR9im9YNkwjNU\/XSF\nN1N7hx52GIDSudYhvRTEpq7tulR7s+DaruxlpsCclFc7ThnX8qp\/06qV53k46eSTY9fvy+XQl82i\nL5fDexZTnW6+\/faK2bNouaYdOzCyuxv15TemuuojH\/1oZPknP\/5x+Jt6mjmvNA3VEPWCIMDM9na8\nvmwZ\/MWLEQTBsALnYQHNLbNmwR85EhOknU89yHSqE\/pbJRPAmmyYLpBJALVOfWVotvUwJwlw1M72\nNWtKPy68EAdt3Ii6PXvCvPkLFuC5Z591bqNaJWFPeJtnvPyysQ3Z29w1axYayjcQ1cCVCpwBfvAS\n4uzny9B8yOzZeO3VV523D9eurpxN36ls0us\/97nSQ5eeh76GBuQ6OiJPb3PtyTaKixeHN549TU3w\ndu9W3hQk4V12HgfKN8J++Vs1c0a1igvPNC8uwHbOmhVC8v9n78vD7CjKvX8955zZskySWTIzmcnO\nckU\/F\/QCIgmiLAqyq6ghkAAJCRDA6\/N8j2TiPwnqpwKyhJCETDY2BVkCYXNh0XuvihuorElISDL7\nnpnMZGbO6e+P6epUV9fefWYGnd\/znOec01X11tvV3VW\/fuutt\/zIGTk5yOTlIUGi1sTgnsHChDDr\npPGO90yZAgDoeuCB8ItABNk2xDpKPpowkz0CWAuzCeK2kBODgUl+U+s\/AV3GlCTLiDEA9I0fjy4S\nmpBaYyHStWHDBql+bHwK13VRvmQJAKC0vR3jenuROziIFGddFA\/nnnee\/3vnM89wxwB6MSAQ7PeI\ntdlxHCSJFZribps3b8aiRYu0dBlJjHrSvGXLFuQkEshxHBQfOQLHCe5tLiLJso1M2OM0eDJMB3dZ\nunTK2ILc9UyahHEdHSi96io0b9qkVSYOIikrT6zOU+vrMZHy6\/3Pk06KlTjHmS+KtZmtg\/7ddfzx\nmLhgAboeeIBLnHXhumK\/ZUA8hUbqO\/zIIyi87DJuWZEMkR50HbJ0no46slT52cgiec3NgXyiBYEh\n\/RgLN8+KTcrwLPuiOkTHbJ65TH4+cvr6rEOV6UJEkG2JNH2Md3z2nDkYmDgxkEbOMX\/vXvRVVh71\n6WZ8nHnfKsRhwdWR8R8f+QgAz8rshZnTqTPu89CFyfNOL\/yz1Stb+XT6Lhv5LHSJ8kAqhc6JE9FK\nxecGhizEPJRdfbWxLqKZOdG5OY7jE+0GBNugYulSAEPW6TIq9r0INIF+escOrjWZ\/Obp5zgO5rS2\nYtett8K55ZYPFXEe1aR569atPtFlPwBCfswEvN+qaWtWHl3eljSb5DceUGtqgFtvHbK05ecj5Vmk\ndOXaEmfdcoQ4AxgVxFknv4o4N8yeLbQ2E9kA4HjXhmCQ2uyE16Hp6i9zv2CJHSHZOlYzGyJMHzex\nmKvqEBFc+jjt2+s4DhJHjvjHaZC24g0sbN3pwkIpEWPL8KzScZBkX75HlsnvbJNmIJqlWSZHBOKH\nDmDI79\/73VteHvRrjtkCK8prY2EWYdALM6dTdqQIp46cWf\/4h\/9f5MdsIk8nPdvnSfpKk\/KfPfVU\naTqxIu+nIo3wjFiOhYVbNqtnQ5x5afXr1wMA6jz9Kq+9FmXt7ZjU3Y1chSX6K+efD2CIPKsMDHvv\nugszbrgBANCbSqG4rw8tFEeLcz+GbGHUkuZt3orcxA9+gBzHQVV3N5cM83b+41ludQc03Ytm6rYh\nI95Rrb79Hmk2sTYD0SzOOmWjEmcd66+uLrrnKqqThJ8bzM1FkgrbJqoLVIdxePp039qs0k3WofIs\n2aF6qXyizT4IZDsQytpKZtHWgQ55ZtNF7VLohZsjedgyPHn+Mer8+4qLMeEb3wgt2qRheo9Feb7g\nuv4Cx4DOwwBdgmxLWmUvYfSz40PwwmBKsmx0sk0jpLlz+3brerOZT5XXdd1QPGaAT5h16owrj01e\nUTkVcdYhyocLCtBA+a2TiFKqftyGOJsQYZ38snJ1992HOu9YJpPBtGXLcNyBA1ICTcgzAOx46ikA\n4b6errdwcBD1RUXI+f73kaGszaM9osaoJc2EvDgA4Dgo8FZc0vuZ87ZsJKB\/6+zYl0yGmyIOQiuq\nLw75\/tT75MkYx5lSyYalVmcanUbbli3AlVdiIJUKRNYYCYsz\/cDK8srI+oHjjvOtzayLRqAuz7eZ\n1DVIWTKj6M9akHUsw7qyef91y9H5dciuTh2s3jy5+Uy0FplVOZRWU+OHngP42wXLZPPaVWVp0QUh\nzJm8vGFxzyAQvXRkw9JMZggAcbxhQqJN6zCd\/RBBt91d18UJH\/2o\/799xozIdWcrH5uXV44mzCK3\nDPal1Fav4SDLJmVlZJklyn7YVQYmxDjgmuE4wpkV1l9YBRuLMy8tJycH9evXY79HmKuvuw5VLS2Y\nLAl3e\/4FFwAAnnryyZAs4ttM+sq05ylAj22jeWHgqCTN27ZtQ05OzhBpzsnxrczsB5Bbmul0Al5n\nKou9zEPUxYFxICcnJxBFQ+aioUIkixjU5IAQZwAfauJsYm0mdZHvnupqFF1+udTyZGINZ10PeOSN\n\/c8e0+2ATa3IppZ\/XufNS2N\/y85ZJDtEosk1wtDW9DbkVDWrZPN8uTgaFcTX1RAiq71uGd4xlkSr\nyJcM6bw8v1ygLCvbgpRH0cu2HhaqZ304dFBdT50yvlsGtWFLFPJqoku26yB9qIoo76FeGkRE2QRS\nUi15VkXl4rRei\/pOspPg\/rVrQeb3qpYvR3Vrq5BAX3DhhQCAJ594IkCMST0VnZ2oLyqC6x2jx7bR\nSpxHnQPJ9u3b\/YZ1br1VGHdZ5IZhgpycHCQSCeGgx5Orqms43DJ45Tq8RSelV10lrVcEnQfO1FpJ\no23LFrSVlOC9448PHP\/Pk06KTT\/dfGSQtrUyHfAGEWDI2ixETY2RXqb5aP0ymUzgQ5+jrkVIVg8t\nUwciHVjrpegjOh9WN4J333lHqzx7POO6yHhpgwUFmPCtb4XzKD7pdFr6X3RM9CmbN88nlHBdpPPy\nsqKT7oduO9l1pK9LlPvdzWSGwutRLzW6cuO87+PIwysTB1GUXRPZueu03yc\/9Sn\/v++WQRFmk75A\nl9Bno711dRQR5oFUCu8ce6xPmFtqa2MhzAQ247+sTBx8RZXGGhgP3Hsv\/ueRR\/DGjBloHz9eKOvC\niy7ChRddFOJWhZ71muZ6vsHUI86jDaOONGcyGZ\/I5uTkIEORWh5xpmFiZbZxODcluqY3pIlMvzOg\niNlAfn4k2ao38qgy2rwHwIQ421iMTDp0W+LMypEk+p+B\/PzQttzG8jj6DdfUvQ7ZlZHiqHXLCLyM\nKEvTvDihUXXkkX6dduJ9DldV+S4JrDVW9ZG9NMnSTK8pfd5sG\/DahG57ssV0mlosx5Onezyue0wX\nvLpo1wwSak5VRlWH7FqRPKZ6q9JpwkzcMtqPOSZwDXXrGq7rIapfhVM++1mc8tnPho4fLijwyTIh\nyjZkWYfEcsdVakzXlauTZpJfpnsikQgFS9i\/dq1PnhuKioT1XXjRRbjo4ouFdRGORRPn0YZRRZq3\nbdsWasAUgJS3AyAdao5nDTYlzCLizebXhW6ZuG4EtmMi1uaSxYtjkwnEa7W2Ic4q\/Wz0MJFHR2sg\nU66DzIAvlEHF2+yprtYe\/E0Jju6A1nzMMf7vj5xwgtXAazsYZoXgCMicqr5AmmfZ7JsyRdm+Ua29\nOp9MJoPuadN8Uvn+a68ZlTXVy9bqrLJCq641eSEg2zATGXmtrXAB\/yN7CYhyH5nqS8qoQPszi+Tp\nvqTEAd0+hK1zPzWj5rqukswF8saQh9U\/rrw8skxCxL1z7LHYX10du1WZ1i8OxGW8U6XruqmSfPvX\nrsWfH3wQT+\/YISXPnzp40C9T6QUJIGSZ5WBbt26V6j\/cGDWkmUTLoE30pNFS3o1Gv4WQ\/wQ6lmPy\n9sKWJVDdPHHcqFEIs6isu3Kl\/5tYm6MiasdtS5zjJMS6+XTOlc1Dpi0B4OOf+IS0rgABSKUwccGC\nWAdpGqIpdBlsrrXNAK8ionGQBZ5eqvro6zNYUICiyy8Xnp8JAbEl26Rs97RpGMzNtSa4KuIcN3nW\nLUvQOWsWt41zBgYC7S26zjbXhHv9DcrqEtyObduM8rPnooLu+es+V67r4lMnnuj\/7540CQDQTr1k\n6yBOwjxcZLmluBh7Zs1CQ3l51lwwdPTrKimxkq173FSOLC\/55hFn8vu17dul5PlTBw\/ixLo65A8M\nBHgZbWUmx7dF2Ewnbowa0uy6bsAtQ+bLrALPyiza7IQHXb9kUR6V3GxOOXRWVgKIZm2mEYXI2BDn\nk04+OfZONRvEuaWqipvGJa2UhaZ\/4kQj3XX1F+lpUlfUa60iI7r1y0iaSJYOaWDl6JBBlR7Z\/nRX\nVmZVftRzotvfBL7PNufa0feTTGddmNyDMhk66KFmK+KqQ3XNoujMk9E3bhyaSf\/mukf9yy31j0On\nKHJFZPnd447Dnlmz0FpcjNbNm7NmWY5y3\/Fgykd0ysiMiKqytDGSLkvKEfL8NyqGNY0T6+pw6euv\nI+f73w+UJ3JHG3EeFaR569atIQuz423cAfAJqYiksheY9b8RIVtTGHFBuQhv5Uo\/T1zW5oB8y4df\nZulQEWfd+uLurFUDkSq4v0xGr+fvOGnhQiPSIiNtunoQvY9QCzZ4MkRyTQgUjwRFIWUi8jpo4PMr\nzLdyJdKOAzeTQeLwYWtd4xogS994A6VvvIHy115D+WuvRZYHqK2RcZJnrbwW7ahbV1wvOroyPvqx\nj\/k6tU2frt0Ouu3PtoHutdbJR0BbmUl4uf4JE7TvZ9P6eMdtnx9ZGRFZfn\/2bLiui9bNm4f2E8gC\niF46\/CDNCXmrg7h4SRRrMwFvkzn6\/\/61a\/G36mr8rboa\/ZzzvfT117nGUfr\/aHDVGHHSTO\/6x5rk\nAaCMCmUiiscsIs26oeRkpDubjvVxgzykcVub2TpsiQGvLCHOvdSueTb1xZ1HlpekdU+e7B\/7xCc\/\nyR0M\/f\/egjMgHA\/YpD1lZCKOgVZGGkzLc9vB8N4xuf665IuHnHQak3ftMtLNRhedD1w3EMM4qjwT\n4jMc9QBBSzOLnIGBIcsm+UDfCmvbN\/Hk2aJdc2C3uTY6+XTl8TDo9U3tW7caPXemedh2tmlvWd08\n63JrcTHenz0bwFAkjGySZdPzyViSZkCfOEdZp6VbVrV474N77sG+u+\/GmxUV6Ob0AV\/92tfwta9\/\nXepxMNIYcdLsui7X+Zs0VCoj39WMBu1nw7MuqyzWovxR3+aiXmjtOjiRNLKFKIMK26m0bdmCA9On\nB4jzSSefLMwfRSeTPHRe3uDMumjo1tc5cyYAYDK161HcA6iM1DRb+CmaukuY6BYFvAgMqvp4n4zr\noj8\/39dn8hVXxEIi4yCeI6VHqI1icFn5yAknABhaSCvK4\/T3o7ChIXD+ousaB+K6F3lRM2T16cKk\nX7DJR1uZyeK\/SQsXRq6PPU9RO9v2HyLwrMvvHHssWoqL4bou1w0jznuJB9UYbmtp1pWvA5v9J3jH\nWFdYnpFz391349c\/+xnqPXdFFl\/7+tf9\/CxxHmk3jRElzVu3blX6Med7i0L23X23f4yA5\/MsW+in\ngulbmY5VerjfjMhDO1BQACA71ma6riidDV2eEGcaLHHWtXjq1KubR3SOupaYQH3USw1x05jMbBea\njcGU5CWf0vfeE6bpkDi2jC1kZGy4iSVqajDoPTNW5WNEQmPjnGzA9hxt2qnDe3Fs27IllCdncBC5\nhw5h0nvvYeL77wvrjOtco8ogaGP6L1V+U\/mqvDb5aMI8mErBdV1\/9q9n6tSjGakoQDr1sf2nrB\/R\nhQ5ZpgkzvcgPgNQVI+o4bXsvkX0VDpWWZs24ZiJXZWzkHeOly9xi6fyNRUX4a1UV+jleAV+\/7LJA\n3tESgm7ELc08sgyECTEL2RuO7kWOy0r8+TPOUOaxhbGONTVwXReHKdeBbCPqAEQTZ55\/s6gu0YAc\nN3GWgawyBxCIcaqS1VdcHKleOm+UgZ+OZmAL2XWwJZo6ZSfU1aGwtTWy\/gS9U6b4L5umiErayYeO\n9xu37CjXI25M\/fvflfWTKWs2n23kC9FLmQnYctLNjZhypvXEnVeV7wNqA5MockyecV2o8vKsy\/Qi\nv9HkijESiIvzmJJWHrej5ey7+244joN\/VlSgjeOi+fXLLgtFPXMcZ0StzSO2jfaWLVuQTCZDfsys\nI3hfKoUCsmuMoOEdx+H6L7P5ZMfOPOss+5OBOXF+9ZVXlHmivFW5rov+vDyk+vpQvGgRd0oqG29t\npAMxlU13PO8dfzyOefttaV6efB5xlr0R6+iqytNcVYXxHR3C8iFZK1fC8bY+b587F5N37cLkK64I\n+UGatqNtu9NlberTScvWfZZ76JCWPiY6DBYUINXbCwCYcuWVvtVNR58x6LcDG+ecLiv6zoYeOnl5\n6aL7SfQcmyAuEqzKy1qZAbU\/tuq519Ep7heCk085xf\/NbnkdJ1mO+ow7jnqra2fVqkj1yOrQqZ\/k\nA\/T6VHrc4fX7rjvkfkuMM+w4RZf5Z2Ulxvf14ZMHDgTkfP2yywAADz\/0kC9nJC3OI0KaCWHmvf3w\nfJtFechvUaxA9v\/Z55wT1ylExrz587nHdcg0De7NU1MDrFmD9upqlDFT8TSiEC0VbIlT6+bNKF60\nCL2FhSg4fBjAkLX5D7\/\/PVe+Si5NsGVk20QOQfvWrSH3Ch3QsjLJJHK8l0LdelWyAftrShOVuO6L\nbJHopIEbA6sDd0C45Rb0rFmDxOHDPnGWWeKHo+P++xtvAKOEkEcdzG2QZhbN8pCNFxZbK6mK6Ou8\noEfVzSb\/IWrGzEQGz1ARRQ+T\/DRZBoKEOS6yPFpfhqOQYxPyzCPFovIyuTk5OXBdF+l0WlgXAOwr\nKwMAzG1uxgRqMTQAfOOb38RDDz7o\/9+2bRsWavjex40Rc89g\/ZjJMUDPzYLNy8t\/zpe+hLPPOcf\/\nfBgwb\/58\/3PavHk4bd48a1k56bTvpiHzbVZZCKJ2HKZTWK2bN2N\/dbVwYaCpbnT9Op2\/jhwatIuG\n1rl61gTXdbmLAlX16kx\/mkyR8j4mMkxBZNouKJty5ZXa5yE7PxF0F9Ga1mmjVzbqiEs3E5icH41M\nMsm9V3Q37bDR0UZmD7ObpE4d9Ecn5JyNbqL8rJW5vazMtzKTvmiA8vEXnYOqHhu9dfKz1mWy7TUQ\nnTBnq98D+JyGXQQYx8t4VP9mXXcO1bou9j\/tEcC6bYzv6wMA7L3rLrxXUoK\/TJsWqu+b3\/qW\/1sn\nlHA2MOyW5i1btiCVSglj+pkspiMXgKSf86UvWes1QN24\/ZR1gz5eV1amfdNVNjYCAFKeFTE1MOD\/\nNgVNnH\/76qv+b6kunrX58OTJyDt0CInBQZQsXiwN4E46iWxZnl3XFV5jHvZXV6Nq\/34USizORDag\nb3Wmv0VyVBYhOp120fjUiSfiL3\/+cyhPCKtWAatXw3VdDOTnI+V1GLQeOuep07HH0fmzMnTaOmod\nqnzZWjDXO2UKUn19SPX2onjRoqz5Q45hCKLnUEVebO9r0+dHBLITaBToPr9xkWUeiC8zXSaTTCJx\n+DAywNBYoiDFceihmzdb7hjZIMk8sGNPlHBztvUD+ufLGzNtLN08dw2eXlizBvvuvntIxooVOKa5\nGROovv5bCxbgwQcegOM42L59Oy6\/\/HKt84gLw06aSbQMgL\/YL5DGlOX5MH\/53HOt9CBkuH3CBDRP\nngzHcVC\/fn2gHha6hN5xHDQJ6nUcB2VXXx04VtHYiKKuLi29Wcvz7377W2WZ9unTUbJnj5Z8QO9h\nijr9ryrftmULplx5JQ5UV+PYd97Rlh0HmVPloTsRmYuG7FzpOrqmTcMUz7dZx4c2ysuN67owGRp0\nCctI+pi9\/re\/abkwaOnovWyyGK4BdbTUy0Kn7WyInahMNogETcZ1ITpvVkarYLczlS4jkZfO0ztu\nHAAE+h3XddE3YULkuuLUm9wrnz31VP9YFHeM0fJcAfxwc7ouFDJElaHr5mHqDkK8DAhx\/uCeezD9\n+uuPpgP+GLX3rruAFSvwqYMHAzIJcR4Ja\/OwkmZiZWb9kHWjXtD5dcky2XmmJz8fA6kUXv\/Zz0Ly\nbQd803Ikf9P99weOE4JNyHRJayuKDh1Cygu3J8PnTjvN\/x0i0BQBaJk9GyV79iitzbpgHwLTsjpW\nZ0KcDxcWKq3NrF42Psq6cniD72AqhSRzveh8Mt9zYGgqNNXby10UaKMjLx8PcS2sUHWacWNifb00\nnaeP9gCSycClwhtGjTBicv7p3NxhDzk3XLMVn\/jkJ43y6\/gz8xAnIdJ1QQCgfOEdjtkXnXyf\/sxn\n\/P\/1nnsYnZ5JJv2QmLb1xaE32\/a2hHk0EWQCx3F8l8lDpaUjUj8QzdpMHxfll\/0nxFmUj\/x+\/847\n4a5YgRPr6gJ1EOL8wAMPYMGCBVrnEQeGjTRv3rwZubm5IZcMGqyVmU6fuWIFPv7BB1p19SeTeHPm\nTCQ9p\/OD69ZZxR+UHTf1GdIZOJvuvx+O46CZOlZ61VUoaW1FYW8vCr3FSSJICTQQcgOIC7YEWsda\n2bZlC3DllZi1Z4\/\/EqEizrRsEzeLKHkGc3N90iwjbCJZhzxrs05e0XS2rIwKccjQkc07nk3Cbgv6\nOYn6ommiX9\/48Uj29yPR349kf\/+oHPDjhPDeGEqEizB5Ihiu2Y0oBFA2hZ2tOnXzslbmuOqM8hIm\n6ttMCfOH8rmh4vgDw2NtjpoeVZ+cnByk02n\/eHFXF1omTAjlIxZnAAHyTIjzcC4KHDbbNu1\/LLMy\n8zqTT+zfryTM\/ckkevLz8Y9Zs\/DSM8+g8Z57cHDdOiVhlpF41fHhQPOmTXjrySfx5xdewNvHHON\/\nDiviyX7utNOGSDT1IGZze20C2ZSrKr+sLNn+1LQe3Wm\/KDKA4DbgJ3760\/qy6F0cvWs65corhyw+\nFrvv6eRT7aKnW5dOednHND\/9yevuttJttGNcW5t\/brywbP9KoF9ERNf5UEmJ8H60uW90YFqG3QlQ\np6xMR51FsTobPbF1ARBamUk6b5EtT44sj64u7DHe8c+eemqAMB8uKPjXJMxZhIrX6PIbUX7RjLHK\n0Ej+B\/iZI96v4\/077wQA\/KmiIiDnWwsWDKubxrBYmkVWZhFhdRwHzve+hwsuvFAql7hevFNVhYPr\n1oXkqDDcbhlR8zVv2uT\/bqGmd+bs3St05QhYn88+G+lkUl6jAdkAACAASURBVGtRIAvXtQt9RmBi\nWaF\/O47DddM4+ZRT8Pv\/\/V8tveLIQ3QS5WkvK8Pk5mZumkgWdQCA2I9TVbdOPXFYoKPoEjdoFwbT\nQVKpe00NkMUXSxFo9wWTcHqjBSbXoW\/8eGn+hLdouqiuDp2RNTsK+gVdhSjPmylMDQ26ZVR5Wjdv\nhsu4Hw0UFBwt5y0CjEpERf2ILC9NlgGgc+JENJSX+3rryLLVb7ig2j5bZumN0woctR4TXVgXDPr4\n+N5etHr+9DyXjvfvvBOzbrwRf6qowKcpF70Fl1+ObZnMsFibs07Pa2trhVZm9s2FfF940UVCwtyf\nTKI\/mcQbM2bg1zt24DdPPy0lzHG7ZcgQhUjYlG2prUVLbS3+8Jvf4O1jjkGLwg\/tcy+8gBPeestW\nxciDgo31kpRp3bwZB5jFNiefcorS6kJbZlRhnWwHIZkvo5b1y7M20x1o8aJFQlk2oOsbpHxFbS11\ncVn1RgKm5+y6LooXLbIqZ9O2BH\/9y1+yXmc29RdhMDcXXR75kSExOCiNYS5DHLrKytO7f7ZUVUV+\nLk3y2+b9zH\/+p\/+7d9w4Yd3dXqxcHf107gvd2TI6jSXMLcXFaCgv98e8OPoZXX1M7h1dnYjBq2\/8\neHPFKeiuydLhNyZybLmWLveSGVj3\/PSnAMIW54UWeybYIOuW5mQyGYiYAYitzBddfLFQTn8yiben\nTcOBe++VyqAhuwlsb7RsWZmjoqW2Fi3e75LFi1HS2oqStjZu3uPJhiennaYVfYMG6RCinJepDLoT\neve447jRNEhnZWtRJnXw0tn\/rP68TtJkgZ3runBqatC7Zg3yDx3yiYIo3Bldn421oWPqVBR5IRGz\nCR29bO+jI+PHIym4v+OAjf9\/Ns\/3XwmsO4MMCQFpjkKWooJXd0ttrT9jJIOtdTBuYl03Y0bkBXQ6\n9djkEfkvx7mAne1DZfqIZNBl2TIy+TTIPgqsPzONuP2KZRDVxVqHyTjJ5tU5Jhs3HccBGGLOK0ss\nzq+Vl+MzDQ20AK3nMAqyamnesmVL4M1EZGW++JJLcPEll3Bl9CeTeH369BBhVkHmZ6Pz9mOKKAQ7\n7oG0pbYWbz\/1lO\/\/LLNAf+6006wsSXE8xKbWAmJhOEz5D5\/y2c9yZarq1dGLpyfPgkIwyFntb2rV\naps+XZlHpoMpbK1wcUH33iMfYqGJ29+Xradj7drQ1KnJ82FzviZ5R\/pji8HcXBTRg5zleQ4XVHX3\neYvpdOXo+CvzypnUYYviRYv8zWTi7kNt5MRJmNm25+lq0366bcXLo3LNGClEtVzblKf\/iyzWbJk9\nP\/0pHMfBa+ysVZYNE1klzeyOf0Dw5C\/96ldxyaWXcsv2J5NoKCrCiyeeqOX3E+cx07zDDV3rZfOm\nTf5CwrfmzsVbc+dy8+ruPMh2LHEOYLqyWjdvxv6qKi15Uesz7fR7qQGUngrVbqeamqHrNmuWn592\nC1DpoVvP1N27tWWNFFmR6Taxvt4nXn\/+05+4u8WZfnjn2p+XN6JEdDjrNv3YtDEw5Ks9mJs7au4p\n02vCgg0zKZJtAtl9KatHBro\/km2ZHZDDsX6q6tI9X1E+2sq8x+sHo0auiWpYiAvsOZvEIs8m97Dl\nSjKCHMUw6TgOcm69NVSONrSS38RVI0Scs4iskWaVlfnSr35VWLY7Lw8vPvEE\/nT88QCANLP1Iu+b\nRjbcMkwxnARbp7MnvmBxkGe2Tp0tYE3PRYWW4mL\/N2ttNpGlk66Tp6W2Fs2cbT\/ZfCpLExmo+iZM\nsG7HbBISG\/IXh0xadl5PT9ynxcWh0tLAltqlV10lzR+ViP67QbcdorRPttucZ2nOZt\/He3nRIdU0\nmiorQ64ZpLwsNnY2yTIQJMydEyfCdV2rTUvYthltIIaQdgXR071fdc9xuDiJLZEO\/Kc4o8gNl3bV\nABjinMVzzQpp3rx5s9TKLCLM\/ckknt6xAy8\/9ligTJ83FVt93XXWOmXTcpwNdw8ZonT8LbW1aJk9\nOzbyTOuk0tVUnqhM6+bNaC0uxgDVwYuIs0w3nbpM8\/DKsG2gI6u7tNSfYSlZvDhWQiqzjsUB3sAu\ns+yaIhuRJbikauXK0O6Jw0l6o5LwbH+igHXRsG0P1ezBcCBqu5iWk9XFax86H+tCxsqhXxLZfDJ9\ndPUWgQ0rVz91qjZh5rXHaCTLPPj9zDD0J3EgirWZl266QJFnbQaOWpwZIdL6bZEV0kyfEG1l\/trX\nv46vfu1rofz9iQT+Vl2NFx5\/PChn1SoAQJdgS09dn2VZft08o8U1I5aHqaYGLbNnx06eVQ+7TYcg\ny0\/83ei8trqp8rCDkKiT4\/k1G9fnWZvbKf9m4ssbd4caR0dtQ66ikDWaNMfhmqHjZ0o+pVddlRUC\nSsfPjaONhuNj454BDL30uDGdn+19GfUejwobWTb5gaHNoAi6PNcM9r4n0Xp4OwHK6tTRR6U3u\/Dv\nA4n7nepaxnV9sg3Ry8lIIYrrqqysrkFRtF5Ntls0W8+en\/4Uf5w6lc3ALRcFsZPm2tpa7gl+\/bLL\nQsf6Ewn8taoKz\/3iF9i\/di0APSJsSmB1F\/+NdreMWDsDj5i1zJ6Ngfx8JXk2gemAZiOTWCE6J070\nj3321FOV8nRIksqXUKY37ddsem68\/P7qaoMyIhDiLbPUiohRnAREp17Rp3j\/\/ljqG234V9\/IhPap\nBYD87m6t+yntLUyLG6oXAJlO9AuOyUsyXa+NnnHU0V5aGoj3z2LSvn1D5VeulD77sjSTc2UJ8+6Z\nMwHwNy5RkfcPA1km6B8h0mzDnWzzRfV3JsdZjwVeQAn6fxfbl8bMyWInzYlEIuCakZOTIyTM\/6yo\nwN677tLyXRmk\/JrZdPpYNsixro+0DWHWLZPNDqGzstJ3BXhr7lw0c6wNti4bOh+T6VS6c2zdvBkN\n5eUBNw2TDl23HpM8Td6uiyZyuPm9lxqaNIt2coxCZFXXRjefbltFId5lV1+N\/GHyZybouOeeYaln\nMJUKEOfX\/vjHYal3tIOEnNPtS0T3U5z5aXRMncpdqBblPqfLm0BVprewUCmzffp0pRyVDF3DBBuL\nmRBmOg6z7myQCnH0P3GA9OE8i74NhkN3HV5lu46MZ5Hm\/SacUlaWWJvfnjwZRxi+GCdiJc2bmbfD\nb37rW0LCvPPRR7H3rrv8jU9UIIsBq5Yv56aPhsV\/2ULWHgxqdTTtCvC2F23jzTlzQkVOmzcvax2Q\nivCynS6Z8h2gViGf+rnPBeSpOn8dsqejt04e40HT83Xro9yTdLdAZwecbPt48uqzcX9QfWgr+R\/\/\n8IfY5Jp8suGiAQSJ80icVzY\/NAZzc9Ewe3ZW64vTh14FXj22MC2vOi\/aNePgjBncPH4Yx0RCWbcs\nXVd3Xh4yYxhl4xLd+8+0bDbuGR+S+MzDjagcKKqbhqp+mYWZxvt33onXS0pY4VLZJoiVNJO3gZyc\nHHxrwQJunv5EAs\/8\/OcAENj0RPSmkfO97wEAjuTlcdNlsA2lYoNske6sPrBA4KElflbFixb5U3hv\nzpmDnoKCQJF58+dj3vz5QpFxdDa65Zs3bZL6wBFZUdNt8tADloksFodKSgJlWOJs0tHTx2nSqcKI\nDSoMRsKNoen++0PH4iZ5+T09yO\/p8V8KskkoR8u1HCnYnj8vnfc\/Ltk656ALMhsns4oPkH7eMtSc\nCrSMz512mn+8c+JE1E+diuZNm6zuv+G4b+N8VkY6PvNoCYBgM4NP7y5Nvtk1dACw+4470My6wMR0\n3rGR5i3UVsIiwnwoLw\/P\/PzngcWBgJ6Lg2gxIF3GhhBHSZfVGweGbQDz4gN3VFT4dZYsXuyHqdtX\nWcm1OsuIM0HUTka3HO2iQVubdeXoEmMZiJVEB9ptUlPjD2Z0mTitx7Q8E0vxhxXsecS5UDAuojqS\npNn0\/E0xmEpxX0RGArrnn+1nzYR0mvQxBClBxBySJ51Moru0VClHpJNKDzoPTZgPFxSgrqxM6mct\nkznS\/ZBJ\/bqzhKMVtjP2OhyKeBCo3DQA9eJAkvZ+UVFW3DRifeXJycnB5QsXctMee\/TRoTcChB27\nRWDzDCYSSFGrsE3LZ4PcfhgJs0x2y+zZKNmzJ3isthYlixfjzTlzcMy+fUhRW9sS4vzqK69EqlvV\njnQ5Xt7dM2ce3R5cIUdWl066SAdbsDLZNkp++9vo+a\/\/wriODv9Y6VVXCS0zrG50nklNTdzjUfQe\nLriuC1B1Zgz6grgx9Zpr0LhxY9baINtta3r\/qoiTLgZTKdRTm\/foyBtpYkRD9IIDyJ87W9k2IHJO\nPuUU\/1hXURE3n4rIRbnuqvSBVAr7FLHtTeSNZoTWA7399tD3L38ZWx2vvPyyME00tkSF45htka0z\nXqnqA4Y4JHnZpMvT\/3ffcQfcm27CSdSYB8cJjCE2iMXSvHXrVjiOwyXM\/YkEHvWsy47jBHyYeQ7m\nNNg0sn3ytGXLhHlUx03yqHT7sBFm6Zs5x02D7lCJ1fm9GTPQwbH661idrXVT5CVTjiprs25dNtYT\nm3wiCxcv\/+HbbkMPs5MXu9mGyFI2GiwyKqisn2VXXz0i9ZI2rF+\/npsWh2WXF2M8Drk65xXFmp6N\ndudd59F67\/YxkXLi9qM2bX9ZXU2VlX4\/ycvHumbo9FsqvXmgrcy7PB9r2Y5\/cd1v2QTRjyyW532G\nA\/NPP537iRLZwjRdlMeE5+l6IfC222ax6\/bb8YeyMmU+E8Rmab7iyitDx44kEtjx8MP+ybL+KCyE\nDVtTA6xZg+6iIhR1d2uVjbLaUwcjSZhdV24NtZEJwG\/nzspK39pM3DQIWmprgcWLUVdWho8w2zHP\nmz9f2+Kso6uO9ZnOw1qbVe0UNZ3WVyVHJx9PLg0SSYO2OJsMJq4btNSqysZ9j0cd+Gb94x\/+7\/\/9\nn\/8BRvlgaov\/+e\/\/HpF6TdvSpu2TAwOofucdNGSpD8vGDJAIJBqFbp8tgq0VkORny4naQCSfds1Q\nkWFdnXhg3TKAMGGO8oJBg7U+sojjPolqKBou8PSUWaVNwbMgE0uwTl4uFAskiZxkMonBwUHu9aZJ\ndVcqhYnERSmitTkyad66dSuXMB\/KzcXzDzwAwO6tRvRWcSQvD3lHjmDasmWou+8+Y7k66SqMBguz\nLnG27YRoNw0ecXZdF\/9cvBgz6+owrq\/PT5s3f37ogbRtL11CSnTiTTWqZERNp\/OJrD828nhl3Ftu\nQfeaNXBdF+M6OuA4Dsquvjpr\/qE2904cFkgeJjU2xlqPDdLJZCAE2tRrrkHDhg2x1zNc55atfkyF\n5MCA9vMiOiaCKG82znVCRwfaLa1YtJ42pM6U3JL2puXS\/aWqjaOm04R5IJkMuWXERZZ15dneJzZE\nmUR3OlxQgP5UCi0Rws0R\/YpbWzGutxepgYGAu6Qu5p9+euD\/yy+9FKhD9ZKnc714rhuydndd1w8t\nTOcV\/date9ftt8O9+Wac3NysLKeDrC3jfG77dtC3H2\/VIw1dS3BLSQmmHTxoVNamw5QR\/Wx0wLYE\nxdSqoIRnbQaGiHOxZ00uXrQoZBUgVmcAOIHygyYPJCHPOlYWGUzIc+fEiSjq6gIw1FH\/7re\/9dPj\n8GXW1dUkn8oqEkBNDXrWrEGqrw+53stK6VVX+cRZdA5k2nsCZaW2QRyEzkZG\/uHDscqzQdPatShf\nskSax0SXkSKtBB8GK33Dhg1aVqEoJNP2OgxoRnKJ6+VT20rHoNdzaxTJ7SeRqQTWvbgJNWtlHo4Z\nDhvZjuNok2RCjPtTKQwkk6ijXqbI\/dU3fjwOkcWWEUPNNVJ60i5NpW1tKOztRWpwULj4k4fTP\/95\n\/zdNoKPA5n5NM+67PLJMrNjkWCKRQDqd9v+z9ZI1dL8vLT1KnCNYmyOR5m3btnGtzD\/\/2c8CDtum\n4JJeiszx8qiO66Znq6wMUToBHtmL3KnU1MBdvRoA0DdhAvIPHRJmJRbef86eHbI6zz\/9dOU0kInl\nVZW3edMmuIsX+6TZtDzPGsODKr23sBAFEpJH68L+1pEPAB3l5Sjbu9f\/TyzOKstL0utIiXsDr97h\nIMYmdZQvWYICZlOT4Ro4VShfsgT169dblRfly8YCxzj6ruFwfRDNzKh0ikKKrcu62fe3tbFIu64b\n2mlPJtvfdTFm8krSaZ\/egWQSdd6GMHEbIuIEa4llMZBMoseL\/EGD559dsngxMqnUUcIcM5ruv9+\/\nD1hbKk2oS1pbUdLWppRHE+iXfvMbLR1MLMCA+F4e9F4+TAi34zghIk2Ok\/+7br8dc26+GUdycpBH\n+ldL4hyJNC+84orQsUcefji0upDnyyxz8GbBph\/Jy0N+fz+mLVuGg+vWSfPqpqkw0lYhHcRKdogf\neWkpEgMDSPX1hdw0CAhx3ltZaUWcWd2j+hF3TpiAIo\/o09ZmXnnZdLCOFV+lKyFAUf03A+VraoDV\nq9FTVIRxnZ3+YRNXjajT4Db5bTGZmVb779\/9TphXRTKiou6++1CxdKmwztGKkZghEM0qxgkdnaK4\nbMjkm1jydBHlGRT1W40VFX5IN5KHXkRM7zqqo4fJzB+L92bMQMumTVpkZbifqziJshQxb2giuw70\neNCEoyS6uLUVpRoE+vNnnOH\/pgm0LqkV+TaL0M4sdqfBszzT32xEDdbq7DjOUcIcAfakmXOhjnhb\naNOdpU5MvaBYR0yoPSLXWlrqu2jokm+TjjsO947hhI51VEdGCNTCwKK6OiVxBgBw\/Jx1iTOriw15\nJi4jRRzruMiKFcWfWdfXysSiLitP4KxahZ7VqwOkWZYfCJNPm3qzAVW70bsAAsMbas6GlJm0GW+g\nztb5xemmpgPSDmx7DKRSoXMUWaBMXlBt9WNhWo\/NTJFKhyj161rxCabs3482arZEpx8T5WPHItrK\nzG6SZaKjThnb+0NGlgeSSbRPmIBm6sWi1YAkE7\/x1qoqxHX3RjlfQqKbALzpzZKccMklRgSakGdb\ndyFZWV0\/aNHxnJwc7uyP4zjYdfvtOIndQ8TC2hzb5iZHEgk84S38G9JFbGUwcdkQ3RjpLO4trlP\/\naKvD9ubVnV7srKz0f4tie7qui+ZNm\/B+RQXax48PpM0\/\/XTjqUySX1WOl95JhcVTbR5g6krA6uW6\nbqCOw5QPoe05qeC6LtyaGnRPnBiQV3rVVcLwYTx\/Zl4+G\/1Ucmw\/FUuXRrLokWtj+9HV0TZ0G4uX\nX3opa21pE1bOpr1srxOvrEgX0\/Ow0cVGjqrNoj7\/UXSi+wiCdDKJPq+vlslT1UWn83QbSCaxjwp7\nZypfp4zpPUFCstEYSCYxkEzin7Nn45+zZ+Pd6dPRPHmyH3J1tLiVxOVu5TgO3nz8cbz80kt4+aWX\n8Nbcub7PuQifP+MMn0DrGC1ZvmdiQJUdYzkm+eaFNSZp27dt06pbBjvSzDmZJx54IGQlZpXnizK7\n+CQ\/2Va78tprlfJtrczDQZjjerBMOx3t\/NRUUsvs2f5vQpx5HWRLbS0OlpaGiDPxlbIdOFQdOhmY\nAKBu6lQ\/fd78+Uadvky2Sl\/XddFaXKxzOgH5Jm1B5+\/+yU9C6VOvuYb7nyafce90Z3qesrJsepLS\n+5WXX84KiRPpxpN54N57s9Zucck1OR9TMqpqR55cFlF3GTQtG2f7+TIRJqS2euvm1wEdo563qQmN\nwUQC3T\/+sfRZ0dGPB3oR3XteTGbbe8rmHhHh9M9\/PuC3CwyR5abJk\/Hu9Ol4d\/p0AAgQZZ5Oughs\nmx2Da0Y2eAnhSY0bN+KPzz6Lt+bOVRJoQp5t9VGR4iiyEokEl1Tn5ORE3l7bZpVe6NBDDz4YUi5h\nYQmWumYQeDddOzVdIrNq205JjnaXDBF0O24jMMSZdFrFixYJixDi\/I9ZswLH2c6K6KM7eOhsHKBa\nECerR7UhiGmHbdrWvEFaNVh0cwbGqddcE3lwsYGINJkQOvZcTSzNJgRRRz9d0BsusXqYELy4yJ3t\neZhcp6gvLDI9eXXpnmtcVl0TxNXucVjtaTSUlwvrG0wk0MGk89pRpq8IdBqJLEH7Vevcr3FfNx5Z\n7k8m0T5+PN6prvZdMERE2QSue9SiTzYLi3Iuw9WPE+7TdP\/9aNy4EX\/YuRNvzZ2LZkmYvM+fcQbO\n+MIXrOskfWdasI+H7L\/I2iwrs5uzOZsJIrtntBQUCN0tVK4ZpgsARfmJtVmnflV9I0GWXTe6TzIr\nL66HzO\/IVq70f9MWZxlIx6NDnEldokFSpJcMA0mxyz7bMfMGbRlk9c9itiHXHURVg4foc+hHP0J9\ndTUGE4lAHXR4tCmUPzO7MNJEHxVpsjlHUdvwnmsT8mujg+6HZ222IXjZ0C2bck36FbpNaKQGBrjX\njl1gaXoOqvxxu0wMCqJSiNrA9CVNVy9VPnoxWOlVV\/l5BliLGyNTJF9EpOn8tNsDa2VWgdQR5d6j\nISLLTZMm4d3qahwsLUVLbS2aN23yib0ORPqwx+MKMzfcIHyoYcMG\/OOxx\/DSb34jJc9nfOEL+MIX\nv8hNE7lomHJA3TTgqLWZrWv3HXeErc0GMCPNjJJHEgm8SMWHJR\/Wyqzjw6xlZSaoqYHjODgwffqw\nk9xs1WfbIahk2nY43DKKrbZ5kBFnk0HPSE8P9MITMlXIdv62smV5RCGe6Py2g7VwIKmpQXNlpR8+\ninyIxZl2cdAhRlGsrzKiIqqL95m5ezeOefttX64o\/FGcpE\/WHqpzmbZsmZEevAHG9FxM9I3qmhFF\nR13onofJPWtbp8652J67Tfvw2sS0bQnSySS6iotDRE6lD0mT3Rs0Ye7wrHo6UX2iPJ8iOTKy3ET5\nKovqUOkh6seJlTktMdzowuQaZxs65PkLX\/yikDzzQDiVH25u1SojnUh5NuiEzPMgZG024HWRLM2P\nbd0aUkYXceTPyWT8RVesVSqKL\/NIwfbhMOl0da1xQnidbGdlJZc48wYf4i7x95kzA6LocDY6uut0\nYgTNmzaFQgOpBjDbuuk8vHyiTj72wbWmBs0VFdwkNm50HAO9qbVXty5ynJ0pMNU1TuLIq1\/VRqq6\nWLz4wgtWOptYtmUflSxTfWTQ0YcNJ2paXuc+tdExG5DVYZvGptMxe1krs+rcVOmiNj1YWqrdzqp0\n3Wvsui4+f8YZAcLcn0yicdIkvFNVJSTLunXxroEIfjtbWpmJ7NHAT2gQ8vzW3LnCPCx5Vp0Du7EJ\nDduIZsSAS0d1A4aszV0aM0U8mISx4BxyfGXYlYsm\/sW8BtHxbXYcBx0RtqRk5Y+2G3M4IOqApJ2G\n56rR4RE01x3yb5YRJjLtxSPOJgOSirDIBkSdzllVtxaofCaDrCkZ4mLVKjRUVwvrePWVV\/yyNoOR\nqn6VvroD0rRly1DY26tsnyiEKCox\/eCee0LHqpYv176XZe5DptAd7E2vuepe1G1fFqedc47yOpno\nrCqjo6PuCwgBmb3Rvd4m58fTR1emCr6VedUqretokk4TVXJ\/E6OJ6DrZ1i0C7V8bIMteDOCm++\/X\nvp+jtHs6mczahibDCZkBsmHDBi3yLJJL\/27nxAtn86nSeL7NojxvsjGhNfmftaX5QSq8nC+M44YR\nJbyILC+dn1ibiU\/ch83CTOA49nEPhxukkxmk3g7pUEY80MS5nyIMdCenOyjrWDWBoIsGHb1DdV46\n6bqdrkg\/3XNV6RIacFeuRNeECYFjKWaA1yEaMrIRlXDw6qblVO\/fH8j3q1\/+0liXKKTapL1lhEf0\nOevss5EaHAzIz5YFWedje\/667S2TKTpXk2tmck10n3FV+6QGBrTaIkqby\/QSpfHK0VZmOr+qPpUu\nMvRzXgpV\/baubB7O+MIXQoSZJsusz7LJfW+C0quuQjqZRBvHeGEiy6YNsgkZV6LJM88Y8IUvfhFf\nPPNMbQKsw8t0uRvNS9k1dTbWZj3SLLAaszHwVA1imk8Jb8rD1to8mggzjWw9LDpydTpS13X9tm+r\nrg5M9ekSZxai1bdkMBINGLIOtnHjRuwVuCvoDpy8Y6xOLFgLKX0eKhJhA17bdP\/4x+j3wjLSCxNF\ng7cJITId1HQIDC2vavlybSuzDQHS\/fDqYo\/tu\/vuULnq664zJpHP7tzJbRPTl4FsfEzazOCmsLqW\nOjqqq7YjuTz55Q0N2vVFIcw8mbovFGy5wUQCbk2NkoDLZOhgb2Wl78ssk2l7LjTY8YMQZiBMltm6\ndWA6dvbR4VYtXDNoWaOJp6h0adiwAb978UWh5fmLZ56JM886y\/\/PRh2S1aVDuEWRNXi8ctftt4et\nzRqwsjQTKzMb\/87GzUFFknXdPHrHjQMgjqTxYcNoe8sEODqRl5aKCiPi3HT\/\/Xh72jT0CPzqZKRO\npptNm+kM0ibETFcvWyLHKytCqq8PrusGQrZVLF2KiqVLQ8QhysCuIp2m5LSCISIvvvCCdduR\/KOF\nVOrcDyNBim3STM7\/heef556z7H5S1anTfjb3tOge5clI9vejfMkSbeIvqkNWt+6zKUoru\/rqQBpv\ncZrqPGXySRrtmkH37bL2MO0feWkhd4yiogBhVsHkvlCBWJl5W5P\/q0CH3zVs2IC35s4V7gJJE2fg\n6L4bUeoU5eXxU\/p3wNqsUY9OWAuuUnTFspBzWXeVoHybSWdQsXRppFAm\/65QdW5cUMSZfrsmoY1E\ng0\/T\/fdjN7UBCTA0haPqmFSDEi9N5Tsq6pB16tQd0KJANHjz2pb+AMDs99\/35bxz7LH+78prr9Ua\nzFQfnj4iwiIjMuQ3z8qsc\/46pC4OMsxrm7133RU6Nv3664Vyz7zwQuv2Hu6PCeFW5ScYSCZDYcho\nX3Cd50lUl+75qPLJnonf\/PrXyufGVDdT0q0LnqyuO+4Q6i07F5M69lZWonHjRum5qM5T1d+wC836\nk0m8PW0aGidNQtP992tF7NDVRQdkzAsssuRYmXXO+18B9evX4\/dPP40358zhpp951lk4wZsFbSkp\nARCMnKFrMNU1urLr7wDgvdtuM7Y2G1uaH9i+3bSIvpayvAAAIABJREFU0FdF1QDciBmS8HXN1FbP\nuvqMNtC6ZbvzNEmXwusYukpK0F1U5HdqPOJMo+n++\/GGN3gSfPHMM5WDF9FXNbgRsH7NdBqvQ1bV\nqaOfjp5R69DJl5KEmiPEWVWnCfmQkVpdkkL7+j737LPGlk9ba6iK0Mh0eP\/OO0PlZtxwA1cXma\/n\naPqo2oW9N1Ty6Ov7kd27uXUR8BZZ2l473byqe56Xl9yrOs+iSd9h2s\/QZWRgQ1Lq9DEinURl+706\nVOdlk07wxTPPDPzvzs\/H29OmAQiGtzNpQ912liHq4r84dIgTusEbRHkcx0H9+vX49a9+JbQ6n8Ds\na2BSjwmxlgWcOKIRFplAnpOp5AjF1EXRMkwb2cSlQ5iHepsj1mZ6YwctGaMUJp1mNnVQ5lm5EgDQ\nM2kSeqg3N3YBCg884kzXrerUZR1w48aNOMh0YvRgqitTd8BQ6alDyEwGXZG8iqVLUdzSEijPmwKj\nfcpEeumSE1le0bnQ9VQtX46P7N4dyhcXAR4JkknS0uk0MpkMLrjwQozv6wuc4xOPP450Oq39iVtn\nk+O2BJt3D8jK6+in+5yJ5MvuD1OypXOvqfoUGXTam0XnxImB\/+lkEk1r12pdI5N+yHXdQPjQDtqf\nlymnkqcDenzoTybxxowZ2OPNWrI+1LxrLoOuDizY3f8ASH2ZdZ+R0cxXTIM8yKzOZwk23BL5KOvm\nZcHGcibIo17qVS4aRjGPHt26FTmckB48RH1DML1ZnFWrgDVr0J+XhwLv7b98yRI0bNhgJCebIBts\nZAuvvPyyVTnbjoKU9cuvXAmsWeMT57K9ewEMEWfRVFnT\/fej7Oqr0Z2fHyITPB1F94XrindVdN2h\nmL9stAKZTPq8ZPci3Xaqe9aknWnLnK3MokOH\/N+\/\/tWvAACT\/+u\/UOjFbCZlK6+9FgfuvVcp20R\/\ndgCW5XPdIavsCZQrCQDsfOYZQEK6bXTTbVdWpo78Xbffjtk33RQ4NnPFCuz2psNF94eJTlFh2i\/r\nLr6x6UPY9qXlsN88XVQkQzVrx3u+yW\/da2+zxTtbp6ge3X5HJ286mUR\/bq6Rjjy5Ote5afLkkLVX\nVp8JWML8VmUl4A65++lwBnJ+Mq4hG0tkIFZmuqTs\/EYDIR7uiF11992HOgCnnH8+xjFueGf99rd4\nkaOTjo6yPHRaTk5O4OWJGIB\/X1qKk6ldc2XQJs0887XuTn+837z\/NmBldEyZgoKeHq282UC2ibEM\n9E5MLF5+6SUrmSoLQCitpgZYswbAkNW5sL0dwNE3cR55bty4Ee7VV2NOYyPGHzkCYKhz5IUZ0+nQ\neQ9Qd34+Jnd3C89B9tDpkGcAQ7vvSfSVQdeipZNn2rJlcMF3zWj98Y+R+c53MI7Z7KRq+XLs96xQ\nujAhrjJi6LouZtXXc4\/zyBOvPh1iroLufS7T5b3bbsPcb387kGfWjTcCACqolxiCnz3yCMC8zNnA\npm\/T7Zt1fQZNdSD3xMwVK4yfGx2rnKivkOUTkVEVKSXnotseOqQ3Con2DvrH+\/Py0MnxZVbJoJ8\/\nUf30QjyyADAO8s3moRePtY0bh\/3FxQCC1mVeXSLZvBckOl2H3wBBK7Mvq6YGGOWEOQ7okm6Sj3z\/\n744dqLz22tDM4llnnw0A3IXDPDkmegJHryt9X++6\/XbMuflmbVniu4K5qH+ZMiXgmsHbS9yWFOuU\n48kP5femQ\/qpaWjipmFj+VZh3vz5oc9oxemf\/3zoA6h996ysBF44o+6iIvQzETJE7hq8hYGs3xqv\nfvrmJx\/eNJyMMIvKyOrjpbH4za9\/LWxTU3cM0ynwkrY2\/\/cvX3wxkNb+k59gf0VFqGzV8uWovu46\noQ4i3em6babvT\/3GNzCOmWXY8dRT0ul51k2Bl492Z6B1V7k9pNNpDA4OBj4i9wjesXcov35S54l1\ndahkSPNDDz4Y2d2CvSa2H7Yt6HNmz1+ks8p9hAXx+Wbvh\/fvvFPqLiK7l3TuPRM3DJFcFlXLl1s\/\ns7y8UfoDArKgNp1MolMQllW3TlFettz71IZXonp0zo\/NQxPm\/mQyRJhFOkeBrH15enZ5i9k+TIij\nnWx5HgC8OWcO19f57HPOCZTTnfGKoosutCzNRxIJ7L7jDt81g61Yl\/TqpkdCTQ3a1qxBUVubb3GO\nQ7bMimuLAS\/UyUAyGfjdUlzMJUC5AwO+i0GK+m0LOkQQgNCqcNkDpUwjUTXWrMGkhgbkUqRI5q7x\n+vTp+PgHH3DrEVkGXJdvBaGPt48f7xPnM77wBfzql7+UWneMrToeZhw8aFRGNgCZghBfAJjU1RU4\nHpK9ciX2fv\/7mOnpS6dXLV+OD+65R1qP6b1BDzY0Zq5YEXqhefKJJwCPmIjKifRg21PVpjrnIfqm\n6wgMpt\/5DqZefz2KBgYwUTJ930c9E3FbnnQGGjoP+WaD\/\/PK2db5i8cewyWXXur\/\/\/gHH2A352U1\nnU6H6lK5gtDWIx54abKZKh7o4y88\/7w\/sP\/Hrl14c84cZDKZUBuw9er2KzrlVHnImNKflweXsnyK\n+kuVfBq8FweyALBx40ZjeTKwhPktb8G\/KjqG6jx124EtQ4MYgchaKsdxrLfMZvFhskbLrPY8kNDA\n6UQC\/\/OZz2DawYMhq\/PZ55wjtDjr6iR67ombhnAmyXGEMwVapPmvnpWZQLZVNqucKJ8t4dZN65wy\nBYnBQeQeOWLt22xLlAdSKZ8I1zPWU0D9sAPBm69JkY9nvS1ta0NhX1\/Ib0gGeppNFVZJGzU1aPrJ\nT1D19tuBwzziTPybaeJ85lln+XF6ZYOajDjXr18PLF0aImeyTlNVlw6iEDYd2TJySl6oXnj++cDD\nT5fJ+e530f2d74TuEdd1fYvzvrvvNtZfh8wCQ24LVa2tofL0gKwirrI2EMmU1cH7TedZvHhxSDYX\nixbJF5S4LjQlDRtqa2sBhAk0j2DTzwXJpyKmPKI1c8UKuMyAy7u2KlcSnmzVuMG7T+npXxOUtrVh\nP\/TcEnRcPljYkGhiae64\/Xbp82jiOmHTZ+kYDES6sIT5zYoKONAbQ+k64iSgvPuj1YsLrUOYRwsZ\n1r2Wpq4QJrIOjxsHx3FwcN06uNdeG4qkQRNnE9cM0zzv3XYbTrr8cq1z4JNm6qIeSSSCA61BaI5s\nQ3jzrVoFrF6NtrIylDU0IDE4qEWco5DkwwUFaCgvh+u6RvEhRTDxFeLVRxNt4nM1rbkZ43p7tSzU\nNIEmi8h0wNM59zvfQdPq1Sg+eBA5lOWt9KqrQro3btw4tDAwL8\/3bz7r7LMDG1yIOkKbzl7VqZoQ\nZNd1AzGG4xxgdNII0aXf2FXn3fKjH6EFQNm3v438\/v5Qvhk33AAA2HvXXVwZulZlNu\/sm27Cx5mt\nsgHgsUcfhetZGkV18MhshrJM0642LBEm0Ca\/UUDrLbFcjBaYtEltbS2XRLOr01XW5\/KuLtRPmOD\/\n333HHb6Pty45F7kGip5tmSVZRthlfcWkQ4f8dQEqS7Pohc\/EvZHVj\/xnN\/ciz4OOLJu+kHahI\/Hw\naXmmRge6LD1FDwBveq4fjRs3hp4lFRGV6WJLYlkr84cJsvsyCkzlHKIivBxctw5YtkxInGU6q+pl\nCbfjOEgkEhik+hrdxYDKq52XTmPX7bcjEYNVWfRb56Y1tUCT9OaKCpR7g7OIOLNuCjLQVuSG8nIu\nYXUQfaodiO9GJjoSIk1bpkvb2jCury\/kU0qDDiDPW5xHIO0Ma2rQsno1xnV0YFxnp3+cWJzZsrvK\nyvAJDqni1SebhtEFr\/NUyaTTeTtRRr12JgSakMNjKdcWGjxLHC2j8bbb4K5ejaltbcjnuBRMv\/76\nEHEWDf6yumbfdBNmtLVhCrMQEfAWxXmEmSeTJcI0QXZdd3iIsC1GOWE2hS3B3lxbi0Ve2SOJBCoP\nHcJBbzdXx3GQTqe54wKxJrNpMsuwSA5g5jbBgpR9dudOfPnccwEEY4uLnltePyUj2Kb6yLYkFtUr\ne+kl+XT12lNe7o+vopcPXaszS5j\/Vl0NQGxh1rEoRyHILOgx9MNoZQb4L2lxWZRlIAvV057HAl2\/\njDg\/\/9xzWuQYUHODKFCS5t+XlvqKJBIJbqfFuxFsLNI2xFgo63vfA1avBjC0xTYbUUOXKA+kUtgz\na5b\/n\/hr6RD24SLOpnXRHU+jV450Asfu349ciSWaWBZY8qxF8FatQs\/q1UPh6Pbt89NJ3aRtGzdu\nxNRrrkF\/MunrctbZZ+OF55\/ndvZxWRFoq6SoHEsI6XyVTUft+7988UXtekndsuOq60uszPTg\/ezO\nnb5vsJa8mho0uC7c1atR1dqKJGPxJVZnAIHNPGTnQtprzs03w3VdzG1pwQSORfuRhx9GhiHMNCkm\n36OaGI+Bi9A18\/7nedf7M9626Vs2b0bOwAAcJ7jQnN4CF+AP9jKLNJuft4idzs\/K1SV6pW1t2Ec9\nb6xeOgRVZaUWQUaYeXXqyGbz6RgVZP0Ur+\/UGbcIYaYtzDJruClniEKm2YXucSFb5Fr2kkmnDwcG\nBRb6g+vW4SCORtIgOOdLX8Lzzz0HIJqedNlEIsFdQ+Ed4Bo7RmxeIepNoVXec9PonDIFuUeO4IS3\n3sLxGmSZdrcQLWow1THbN6LsJtK5wWhrdNnVV8N1XRx34ICQQNPTckbW51Wr4K5ejcYZM1By8CAS\nlPyp11wTIM645pqAtVlGalXHAQRION1xyDp\/VdvRVk82xBtPH965iNJ1QBPMj1Jxjp\/duROAOgYw\nTw935Uq4HskV6TNzxQr\/OIlDzJJlOvRaBsBxra1cwrx92zZkPFecMXL8bwDXDft7uy6u5GTdvHmz\nT6Jp8ky+6QWA5Bi559lFjWw6DVMizcO4vj5Mv\/567Lv7br\/fkJFiFjok1WR2lpSRvejT+XRksXro\nyBD1r6Jzpa3M9RMnwnVdnzDrzBTEaVHmYeo11wAYcsvoKC8fOhjT4j8gfsI83NZtXUNfK9l0jFqk\nSpd98YUXcOoFFwRmwQlxtjEkxvVCoEWa6Td\/0wvAW42d7YsYkL9qlZZVmaw03jNrlhZRNn0w43oz\nihs82cRdghBoAFoEmrWuCkmXF8u5ubISkxsbQ5E1SPu7rhvwbabfNGUkWdShDzCkWUZsWYusjpWF\n5+Kiayk2GbTY\/9Ovvx5lXjxsAhFZZvXh6ee6Lvb95CcAgNL\/+3+RzGRQMDAgrJ\/EIWblZahj\/9nY\nGNKldtMmLF68GHrLL8bwLwXN\/mzRokWhY7W1tT6JBhAi0+STpmZKaJJNH5MRaZbk8gjbjqeewvkX\nXABgaJaHfolm5ciIooqEsnXTaVXLl4fiXMsg0oHXB4nSXdcNWAJ5W8ObWKLJ8XO+9CX\/WFthIRom\nTgyMxzq6q6ypUVB29dX+Cx\/rlqEz+6yCjc7sGK56MTOVFycqli41qnNvZSVm1tWFiPNzzz4bKmer\nd05ODtKeG\/JJCxYo8ytJs8yMz3PVkJUxrUckTyafTlORZZooN2zYMGxk3ubCRnXTsL2haAs0WVB4\n\/MGDXAJNVjqTuMBSS6q37Xb7mjWY2NqKAiqyBXmTb9iwAViyBJ88cEAsh9M5ijrM\/mQS4wQyVFCR\nbFm5OI6zaTRhdgGUdXT4ac88\/bQwP3tMdJyg8Qc\/GDq2ejVc10VZTw8meB2YSD6PIDMnAgCjLnrE\nGD4cEM1CsFZpAtrgwz7DsnEMkFua2X4g1yPN06+\/PhCykdcXqkLk0fWJ9ACOxocmGGT8RIEh142D\n69Zx5WcYdxIWKusyQU9+PurXr\/d3w7MhzF\/68pf9Y22FhdgniC3Nk8e7Zq6rv0GJKfrz87Vf\/HQR\nhX9kk7tkg68cycsT5qGPEx9nljh\/6ctfxnPPPmukG\/0yRX8D8BcF6iwGDJNmqvF\/720JaUJaZQqb\nHI8iT0aWietF\/dSpcBxnRLbZHm7LsU0Z3rHmTZuGjlGLIHgEmpBnUYxF1urcuXo10okExlMLBIGj\nG9O0FRb6C8doazMrj+042Y6+nxpQSEQOE+uK6BhZ2CDLo3qJ4EFFegmOY14qZGRYZmFmjwd0vuUW\nuK6LetdF7ne+M3TMu0dO5ezmJzkp\/bxjGIMBZFZpQnbZMHq8GVSRVZqAJWtPPvEELrzoIgDA\/9m3\nD+3jx2NvRr5DIEtW2b5KZWBx3aFoOS4j93BhYSBfaXs7midPNprJklmXeecCwN9sRETCTUh0d16e\nT5gbNmwI9BmmfEHXAqsDOlpGBwklu2qVVtk4rNBxljORmw2uEnDNUIAQ58qmpkDY2C99+cu+GyIB\nzVvoWMyyc6CfP5321HLPkLlmmFiIZWV0IStLh0ljMZBKoXPCBLR4D7fordrUihjlZo+D3I4EiPW5\n7Oqr8VZlZWD7axrEN42QZxFBQ00Nutesgeu6PnGm23XflCmBaAtkekbHZYK+Ro2TJmEqRcxFbZnh\nDHgqTKPeTp9\/7jm\/oze5XrokmRybccMNcIHAS8tTTz4Z2BhERZLZeMW8\/Oxn1w9+gHQ6PURSVG00\nCu7XMfz7QtcqzRJlMmULyK3SvDFgcnc3ZtxwAzdMIw2RywVLonn9EL1zJynXU1CAjh\/8AM87ju\/m\nkPLcqkxmyXTyq6LxsOelImG0lZlY7HmEWWRx1xmLaUOK6bgdiJYxbdrQD4owZ3uWmofhqFPn2umC\nuGbQOzbrchoSx\/lgaWlg7c6Xzz0Xz+7cGXo50tWTJdk6UJLm9267DUnoX6C4XTN0oEOW\/\/GLXwwd\nWLMGRa2tKPRImO3GJ3EgW8RZZ9ojCogM39fM61Bk5Jn1RQ7JW7kS3QASN9+Mgp6e0EPw16qqkJuG\n6u2Rzndw3brQCnN2YBCSeojvR5InVyPkFK+srE6ZLBLJ4nhqB8Inn3gCrmInPZYYs\/kyDOEmH58k\nh09CfaJjGMMoA+9e3rJli79xF02egTBhZgktu9vh1I4O7GFC5LFEWNVPkPxsPjqKDY02bx0CnZ+d\nBZT1aSprsEhnshOgrKyIQANBwtyfSOAfVOg6njyZ1V8XqnIiWUeomOI29fIQ58y9DHGM\/SYEWnS\/\ntJaVDY0bjJWZzs8rW3fffai89lr05OcHXDW+fO652PnMM8bnIdK\/K5WS7uQqJM3\/W1IC9rLwpo9k\nb8Mqi7MOolqWfbJMUFODrltvRReAci+mbRTiHMXaDETzc44TsptINEVH4JNnzxeZR56J5YM48Itk\ndd5xBzpXr8aUpibkejJIvv5EArme9YedmuENAOw5iTp2HSuMSA6x+LCLAGXXU0aMZeUIoZ25YgVc\nILDdOEmXkWReHiKTthyl02lkMhk+SR7DGP5FceWVVwb+b926NeDaAYQXHZJvtu8o7+rCzBUr8P6d\nd3LzsqRN5hJBlyVrGGgMJhKov+su7gvsOGr9AVtHXNZn4vam8xJAf\/PqFRFmnhy2PC+Ot64FmoCX\nl3bL6PJmqnXdMkQyddLiLDPSIFbmqBvBHLj3XmD58oC1GQDOPe88nzhHMQ46joO3Jk\/GSU3ifZiF\nZ0AuTIKzsEDnomXjwhKZ9GYbLIRkmaNXw\/TpIeJsQ4KjEmeil82Ugmke3XpElkpZeT\/qhdfJfKS+\nPmTp0HLgX7UKbV6M7XIq5Nw\/ysvxKcqyytOXPaZLhOn\/ItcdHRnP7tzJHbxkU5cisFOgruti1o03\nwnXd0MYvv3jsMb9euhxrOSa\/2R30xkjyGMYQxBVXXOH\/3rx5MxKJhE\/MWCINDG3O8\/XLLvPLzG1u\nBm68EXt++tNQ3yIjyqK06ddfH3KH6svNRdPtt\/vPPq\/vKm1vxweuOHJHFOszAOwm\/r2C\/DyQ\/ujc\n887zjx2ipu11ZahmAIFoFmjaLaPP24RnJN0ybOvLhlHOhoc0ebs62oboy8nJ0SLOsvK0nzNr3eac\nQGg8l9J+G7eJOG4imQwRYVaR5YBcL+QZwCfONjB5a5fpFydxNgHPVcBWjt+G3kK+j9TV+RZi4Oh0\nHOvEH5DjPVQNa9ZgXGcnJnR1ARjqWCd4Fmj6RYcGOyCYtpVsKpFOJ2AX4onyqWImi\/wEiZxZN94I\nFwgR5kd\/\/nOhHzP5jJHkMYzBHuyzsnXrVjiOExiEHcfBww89hG9885sAgAlHjvgvurvvuIPbLwF8\nKzQ9nsy44QbujGR3QQFaf\/QjOJQsXj83vq8P1dddh\/1r1wbqJ+ARaJXBgXap4MkU1UP\/pwlzfyKB\nd4uLUX\/ffXAExh4d8PS2dcWgCTMAHJ48WUsHHdmqtDjyRx3P4+IXRG+RldmGy4iIs0i2aR1HEgl\/\n86WQTDfMOAAc3QmQnl6ip6rIf5JGvum3ZJ57ButszXO+5rmB0Jtp0BhIJtE5cSL+\/thjobIyuQB8\n4jy+szMQuSGO8HNRy5tYg03zyAiyzHVAdIxnEaVBQsidUF8fIM\/AUeIsrce7ThX798NxnIC1+S\/T\npqF+\/fpQWd5DUrV8ecCl4dmdO42tynR+4prxsb17\/WM7n3lGqw3p4zz3DJb8zr7pJgAI+XU\/+vOf\nhxbz0VtL0\/\/Z6ecxjGEM8WDbtm3+2Lfg8nDk8T9XVgIA9vz0p\/4x0YYq9DcdA50gnUyiOz8fnT\/8\nIVcXUv68r3zFP\/b3mTMDpJmGyuDDI9Vk+3BgyKf5zYoKP6ydiMCz5JUmzaR92L6cxwVE6bpl2C26\n48LLL70k1INFNghz3NZkk1kDWRpxzThcWIgOLyoKCTnLytAZO+nx7rSLLgq5RpIxmJTNMOt8WJdE\n2mWRvOT+R3v7Ub9mHUvzljlzcLxn2QPCF2y4pyREhLlzwgT85amntGRwdfYszt1FRcjt6\/N9aMuX\nLIm0EyAQj6+zrQsGT5e4YSKzYcMGlC9Zgn96UzM08SOdL5lW4cr1rM71a9agYv9+tBYWopiKpkEe\nyvr166WWEp0XAFU6S3BnUzGJn3n6af8BU9Ule\/FgX2pm33QTXNcNuab87JFHAM9qTD\/45Dc9vTyG\nMYwhe1i4cKH\/e2s6jSuYF9QT6+pQN348cNNN2HX77aHydNzmWTfeeJR4UnnIsf1TpgA1Nb5FVref\no31+eZBZn2XEujsvLxAHmpef1SnglpGbCyBMmOlytMXQFNkiySxEoW5fefnlwP+4CXM2xvdsoLO4\neGh8pHYAjIrfPvFEiDgTN40os\/Yyv+asbaPNszKblAOOxvtlMZBMYtfMmYFg6royQ\/CIc9vUqZjS\n2OgTZ3pLZ5EsXcJlS55tibOMnEXRQfQ2qKMncdkoX7IksKCP4NzzzvM35eDBdV1g5Urg2muxd9Ik\nnzR\/6uBB\/MULAVSxdCkcx\/E7cFUnq2tRlmG8ZAGgjDizxJjXxq7rYs7NN8MF8NGGhoCchx96CBkv\nNBMwRJTpgXsMYxjDyOCKK64Arrgi5H9c2d09RF5vuinktxwYVzgyHcfBgONgv7dlvcP0HSrr6uzG\nRoDadMWWiNkYGWQEuj+RwLslJdzzEMkVubkQ0LsKxo2BZBIpwc64Isw\/\/XT\/N0ugVbAZv+KAiWzZ\n+M8LMxcVbH2v\/OIXmH\/JJSHi\/PSOHdLyrD8z7zcP2qTZlgTbQkSYOydMwJ+eeEJbD618GsTZxBdK\nRGJt2k6HkMrSReVN5JqSZDad\/t+wYQNcz12DtZye95WvBIgzSyx1p6hIaLmD69YZEWAR4eVZcqqv\nuw5lzGYssq2rVQSZzUsT5o81NgZeMh7Yvh3wIlyMWZTHMIZRCvJcU\/3HtJ4euMCQ1RnhRX889KZS\naJg0KWBdpvs1UXl6i+9caotvXv98VGV5vy6Dzuya67q+TgDwhhd+rO6++wAOwdb1T+b5WPNAtvvu\nyc\/HAY+ss9CZWXccB5VNTUgNDiJ3YECbSNMEGjhKok34BWBHmEVW\/zig4gStZWVD+VatMuIjuobD\nPeXlATdJAPjK+ecHiLOMl\/Ag8msOkebNs2dDJ8Qzz\/8qjmkHlXW57r77pOWtQRHn0ro6JLyHwMZV\nQ5dM2+pvY+mNIj9ukMV7f1m6FMc0N2NCf7+fdt5XvoKnd+wQdsAH161D5bXXBo73FBRgXG9vIJ\/j\nOD55PnDvvUPbzWpMY\/LAkl6Ccoo072DchEREGeD7gNMEes7NN\/u\/j2ttDRDmbVu3IjM4OOafPIYx\nfFjguoG+p6qnB6W9vfhrcbE\/bopI4q4pU5Dzve8N\/clkAn7QNHHmuTHQskgUI5nl19b63E9FFRHl\n55Ulbhn0mM7LL9KL9qvm6uUR5LZx49BYVBSS1cgs+i9fssRPTyeTaK6sHPpfU8Ml0sQxj6zZIccr\nGxtR2NuL1OCg0jItskLbvtjwoHoJiGu8Z3UmO\/pGDTOnqgfAkL\/+ddeFiDMvvy5fOlBYiDmHDoWO\nc89GdJOqpoBUUF28s84+m1tuIJnEq4ItmU3qU8Ijzs2VlaigIhSIXDVs9LF1nbBx01ClkeNRZJuA\ntazWr18Pd8kSzOzoCPgof+X880MklC4HAC0FBSjxiPJpu3Zhx2c+gykdHf6mNfSAUrV8eag877+u\nb6BocwGZRVlUN2tZBoATRdtSuy7GHDDGMIYPIRirc14mg5OpXUR\/X1qKdydNQo7jwMnJAWpq\/IX3\n7HoHmmjTfQvtF03ysphxww3Yd\/fdoXQZSRPJIqifOFGahz5OW5nf8WIey0g7bR0n6bQ\/NA9\/q64O\nyWMX97N1EYIHHCXMAPz1NLK2obkBTaaBo4S6sqkJRdQ6MR4IgX71lVdCaVEsyyb5smEw810zLMPM\n6fIPHnEWcQkdNOfn65Fmx3FQ7PmG8G6ybLln8Agzz7rM6iOCrZ7OqlXAmjWBUHRA9ohztsuJIHK9\niBuqeurXrweWLsXeSZNwYl2df\/z8Cy7wb3Z2W2uyF30JZV1GTQ3aALTfeismdHWh8PBhJNPpwH1Q\nrui0eFYYVneSZy61SOCpJ5\/0d+Kj9eWVZethLcufYXyXvQSp3mMYwxg+JBA8yyd7H8CLxOG5XjlO\nOEoVSyJJOt3vkPQnn3gCF150EYChTad2lZXUL7aeAAAgAElEQVRJ+zi6DtrwYHaK+v3VgXvv9duE\n1oFXLx0NhEZ\/IoFWypoMmEXAIoTZcZwAYXYkG5jw2pBXH+EMTY7jE+jpBw6gkB67GMybP9\/\/zSPQ\nKsTB0WxdOQhPoa3MJGKGbtko2L92LWYz\/s3nX3ABnnrySa162bY7kpMD1hs7QJqPeL68Bek0+nJz\nUTg4iDk33xwIk6OCbKqJB5l1+eVnn9XeD5zA9kEHKH09i3PD9OlaiwNt6skGcdaxNuu4dugcU\/3X\nOT+Sh2yP+efKShzb0uK7a5x\/wQV48okntGW6rgv3llvQ5Tjo8sLUlba0IF+wJSYJGbd\/7dqQbJF\/\nMrEy0zseuq6rJMq0TJ94f\/vbAIBP19eL40KOEeYxjOHfCmRB77Zt2wAgEAeaWJ9p4kwbFWSkd\/yR\nI\/hIfT3gWZtFM2kEKuuzqJzOcZ0ypD7aOk2jP5HwIzIBQAMdfYORIdKdJswAQhZmFiILvIynkDKE\nOzTiqAV6zt69SEm2bCYEWoc8RyXLotloWbpKD95mJnEbAFnsKS\/HcQcOhDZWo+vW1aErlUIpK8Ol\nStbW1iInJwfTb7kFmWQSE\/v74ThDsZrZh5Z9G6SPiW5Utoxoleubc+bg4Lp1wjdO0XECU6ItlOUR\nL5o4A4iFOBOY3jwmZJR3zKRzU7kzsMdExJH9L3JjqLz2Wriui5kdHUErMhAgzwAwbdkyzOrsDOTj\nvU2mv\/99AMCsujqUd3WhwrM2\/7WqCoD42pMpTBYzbrgB5Z2dvtX6cW8zHRFRps81k8n4RNl13ZD+\nIYwR5jGMYQwIbukNDI1xtAWaHnN54+8ll17q\/\/5bdTX23nVXKI8IvDw0kf1rVZUflUME13V9izcw\ntMjqjdLSQKg6Xp0XXHhh4Hh\/IoHWwkLfJcRxHNTdd58w5jUBnU7SaJcMx3HQO24cOqdMAVatEraL\niI+I\/uu278e\/8pUhP2gJgQb45DkbZDlKPtKudFxm9iVEd9G8qG5ZiFYAmHfJJaHIVoQf0C6R7KZf\nAPxdd13XxVsTJmDR7t0BOQFLM2n89ydPRoHrYmJbG\/fEeDC9cCLC3Dx5svBB0qnLVA9pfmpxYFFr\nKwp6egDEZ3Em9ZsQZ538IquyrLyNdZkcoy0dtJVAh3TTIIv89k6ahL2TJuHTIt9e8F00eLolbrll\nKO2667gklFcGQMBvOUCCEXTzEL2MZDKZgNsF+Xa974+3tAjPbYwsj2EMY6BBIuRs2bLF913OUAsD\nWQJNW9RYzG1qgnvDDb4xjC7Hg8pVQ4fksJARZoBPlv8+dWpABzqus2h6nRxjxzGWMAOwIsw8yHQR\nyXzdixpFLNDHvfsuNz9teY7DDSNu7kG7ZQTiMlvIioJXHnsMZ154IdfaTIPs6MnDrilT4HDKc32a\n89JpQPLmJnuzEkHHwvzLF19UyokTWjedR5w7i4vRWVzs+zmPVuKsIycO4qxyA9HJS\/Sl00lHOm3Z\nMrxWXu77+F540UV44vHH\/TLk2tFuDTy\/PPoa01EoPigvh+u6mNrejmQ6jSQjQ4QTKCL\/l2nTAjt2\nhSzMzHHXdVF56BCqqEWPTGNI6x7DGMbw7w06as62bdt81w3S1xFCzRLnxx59FJd+9asAjrqWiYwa\nJuRYlY\/8vujii\/1jRxKJgGWP5Ra0RZrg71OnAoA\/Aw2Au0eDjNwT+TRhBryFfxUVgMSH2ZZIq8g8\nC59TXHMNiltbUdLaypVLyPNvX31VWr9KL1PocpVmzy3DcRxh3HEdDhFFr7enTcP\/2bfP\/3\/BhRf6\n1mYdrgPAX99Hw8yPIQbwCPNAMhkizDY3qcmbl9FbGvWm1DB9uv976jXXBMLNREEUCzk93aAr03b6\nSeX3xOqk0lkEQp5fKy\/3j1108cUhy25LQQG3blU97sqVQE0NGidPxsHiYuwrK0NfKiXUBxgKMcdu\nykLXIfpkMhmk02l8vLk5TJhd9+hnDGMYwxg0sXDhQixcuBCDg4NIp9P+h+wQSu8UylrT5jY3Y9aN\nN\/rpvI8Jqq+7LlROJOP1kpKhBYBUPtd1cdHFF4dcOP5UUeFvsU1vWqWCyDpONtsgyKRSAcKsS25l\nx3lpbLuqxvvGjRvx5uOP49VXXkGLF2WEh9PmzcNp8+ZJZbGIauEV6U5eRvrz8o4SZcuIGSrouODy\nXIbYGQwVUpy2CtRM3lRZzL7pJj+dzmsKXgDygWQSL+3caSxLhqyY\/QXEGUCsxFmnXU06NZlMk+Ns\nnbzZBl29VNYAAt703cWXXBLQ5+C4cX4abc0IuER4v2nC63diK1cOdZirVqHhttuwt6wMe8vKcCgv\nD4fy8tCVm+vnraDCz\/y5spI7yPDIcmV3N05ubkYeGbjGiPIYxjCGmLBo0SIsXLgQl19+OQYHB\/1+\nhyXPP3vkEb\/MBM\/aPPumm\/y+SodA8\/p4skmVrAzBkUSCK4f063S+v5eVwXGGdnilLcysLiJewo5J\nbHz\/vvHj0VRRAbemRjgm2YydJmO4zsvKm48\/jt+++ioOFxYK5ekQZ5uXIVOkk0m0eRuZqJCtFxRy\nzHEcvDFjhpEswnVlCDFkWmDau8HjQByEOQ4fnkhyGOJMbw0ZF3EGwg+e6qEydY8xOS56Y1flkXVe\nbB7VdCBtbQaOdrD7164FAHR5QfLZsqT89Ouvh+u6\/kDBImCRueUWZG65BU0\/\/CGafvhDvwy9jfUf\nqqrQm0yiM5XCe5Mm4V3v805REd6ZOBFHAHTn5OCkpiac3NyM6p6eMaI8hjGMIeu44oorsGDBAgwM\nDPj9WpraPZTGMc3NoWOEQLNEmvwWQUSuXdcNEOJDTF+dyWQC6UcSCRwcPx5\/94gXz3AiIs+iPJXX\nXsslzB1TpvhjOj1GqazBUXyeTQk1fexPzz2HV195RUieZVbnuMkyex4yK7MN39J1e1FBZm3WMQIX\nDg6itrY2cIxv4\/ZOdiCRsPJfZsHbuYcmzKYybYmjTV0h1NT47dM2daqUOKum7VUfE+i84ZpalmX5\ndHSkOyIZoWa\/adlkGu+Pnk8bwSWXXurneXvyZP84PTjQcmZ2dHDPkZeX7azKu7oCVur3f\/xjHPh\/\n\/w8N3\/8+MitX+kQ7\/d3vYvC738Xn6utxRl3dGEkewxjGMCJYtGgRFixY4FueCXl+6MEH\/TwktCft\npkGgGpvI+hIWhGDT\/2nsmTgRH9xzjy+H+FkDRyNq1I0fjwP33osD996rNcaw9bOEmc1TX10dIsy8\n8zDhGXERZjqvKP+fnnsO7x53nJI823IJEx0BZvGfIFoGC9WLSZx4xltkqQJPl30\/+UnomNAxxHEc\nDBqGbuNBRJh\/88wzwjLD0ZBRQQKf84jz1GuuifVG1Z3yIXlt0kV+yyI3DFFZE+szDzyrNrEos8T5\n0q9+NaQLIdNsh0Gvov3FY48JyTL9IYv8Kim3jEcefjg07ZnJZDA4OIiFCxeObW89hjGMYdTgyiuv\nDLhtZDIZPLB9u5\/+0cZGuO7QBku0lVlmUJARMTofa5kmrm4EhDAfSSTwx6lT8UbpUERc1rosGo9E\nxheiH2tdBoA6L9Sou3KlcAaVlhfF8myah+TTyduwYYNPnruoTV1o0JukDAeaqZjZLIaD08nqeJ1x\nqaV953kcRyYrwIoTnjsGKTBI\/aejBOgo6zgOlzD35OdLCbNJHSMlw39AvfA07eXlyKRSgTR2hW4c\nyDZxBuTTHjJXDTpdt24RUefpQ4jzHzj+Uq7r+r5yPFmu6\/pWFQLe1COtP\/H1+2jj0U1RH37ooRBZ\nHhgYGCPLYxjDGEY1CHlm3Szy0ml8ur4eruti9k03hfpBmiTLFhaSvLJjb02a5B+jCfPrJSV+HrLR\nFD3O8MYJlQFm2rJlobS6qqohYxfHJYOGyl1QJy+drkuqbfhJw4YN+NuOHXj3uOO46dkmzmRhZTpJ\nBWLTtDIT2PIyk3If3HNPiDjzZikIBqmY6CzEpuSaGrQXFuJQHruJoBykIh5hbh8\/Hr9lNqmIAzru\nBVEJs\/Cm9m6Q5spKdHtvfCRvxdKlqFi6NNa3rLgeQpGrhW6HoSK8ulZltl7Wkk2X3b92LRzHCRDn\nk7ztrNnd9FTkn62fBgluXnnoUEAuvTqdkOVFixYJ6xnDGMYwhtEEEnFj29atgeOfrq\/Hx5qaMPfb\n3w5F3mDBOzajvT3k3gEErckA8G5REb76ta\/5+QhhdhzH79\/Jf9mMp4g8T1u2jEuYD06bFtgWmydP\nZBDSnYWVlZPliYMfNGzYINw1cN78+VzyTOq2rZ\/eTbGF7KRoEbZvONFN8VlibZZxFV77+KR5K\/MQ\nETRPmMAVxgPJc+5554XS+pNJ\/OHRR7lK2cDE\/SEOwiyF5+fcXVQUWiAIDN1c9A0ax4MSl9VZRXhl\nZFrVsYncNmRyeRYGur2IY39zfr5fhhBn3rmpLNg0MplMYEalsrvb\/\/3A9u0BN4wxsjyGMYzhw4qF\nCxdiM7PAKS+dhuu6gV1LReSZ\/Z+XTmPmihXCPrcrlYLrurj8vff8Y7Txg8wk0mDHDB5IWtXy5T5Z\npsumEwmfMKtmSnmWZx2DnEhWHHlkZXlc4tVXXpG6a4j4RxRder0IVlHPJ448Muy7+27sZlw8RRig\nZq6FpFkG4tssc9Eg4BFmAPj1jh06VSnf9IYTxuSWWiDYzdy4PHeNqOTZxOpMQ8eyTPKJ5Ig6IBtL\ntSxdJG\/PxInoEsRVpqcUZ65YEfBJBhDy2+OFW\/oYRcS3b9s2Zlkewxj+P3tvHl5HcaaLv336HC2W\nrF22vO+syZ1kMpkJIZh9JySB5Dckk7Bk7iVgvGNyGfuIP64lExLAG3vugA1OSAYISxJ2MGswJGSZ\n3CRs3vBu2ZItyZYsnXP698fpalVX19rdR5LDeZ9Hj07X8tXXW9XbX331VRF\/V7jqqqsCC5U\/v3u3\nz8cZgK+fpPvI\/\/r5z716xP2N5xMNABtHjsQX2tq8Y5Yws8YS1uAic9kYP2uW7xwsy\/LI8u6mpoCF\nWcclQ0SMad1EHwhxuWyY1KXJ8J9++Ut8eNxx3Pqy0HQmOhE+4209DkitzGHaKBTaqTC1dOQWUbg5\nNgyz54hiu7v0+JBOA62t6EmlkGJ8Qgnoi3DRl7\/MLfPM008L1FdD9mXIth8mP646Hlzi3N3Sgu7q\natTt2YMSN2wZedB233efsD0TCzpdX8eXWPaS86bWSPpZZ59trJMpnnrySakutK4f33EHJs6ejb\/W\n1OCEAwdQ1d\/vK0OeGXK+tD8z3dGzgwKxsHyeCi+3cMEC3P6d78R0lkUUUUQRwwyOA1Bj0Od378Y7\no0dj+sKF+PC227y+VMflLi\/OCfTjPML88R135IkewG2DbYctM37WLG75wyNGoKO2FkinpToT\/Xh7\nU7BWbhnR1SnDa98UJvV333cfdgP4wplnIsWMj4Q4h91NkBstwyXMYfiLCCa8RhdbV6+GM3s26g4d\nksqSBcEIbKPNCrEsC20jR6JKsJ2jCk\/\/+tfc7S4HAyrCzUNsX0Lu9tvto0ej8uBBVB486GWJyDPd\nvunDJ6vHTjeJiPPpZ5xh1GacuPgrXwmkPcHxfyf39OM77sCYuXO5xJm1SrCLAHk+zdMXLvSRZbcA\nbo90VkUUUUQRRwEY4vwP+\/bhTw0NmL5wISzLwke33y619uZFDOTLYjoTyAiy4zg+Mku3OeG667j1\ns8kkdo8e7ZFlHZJPj4eq2U0dPqHjF22KKHU3vPQSTrjkEtTv2xfIO2XmzABxVpFQmjDzomWYktjh\ngEsuvRSPPvKId+wR5nTam4m5\/\/778d3vfhcA5Z6hOlESSWPy3Lnc\/C9ffHEg7WnFxiVRCarOV4gu\norpKcEGszq6vMwtZhA2R75EK7NSRbPro9DPO8P3Fgb6k9DvMCF\/92tfwtUsuwdcuucSbRqE7thLH\nQca28deamoCrhuM4XHci3iKXaQsWYAr1UeMKiO08iiiiiCKGPag+rzSbxT\/s2+eNIdMWLAj4OmeZ\nxdfAQNQhx3Hwr5ddFsh\/3fUpJT7MLFHmzbqStImzZ3uEmcXhigofYebVZ6E7tvLcEtl80WxxIVwx\nTPHXX\/zCyF1D1WaAMGu4ZRCofMpViIOUb1292ueiwaLfttEvsTRbjqvBQ27sRnKjEokEbLK5SUsL\nRh86hMreXliWha2rV\/vIC89KSBNmka8SOy0iumiifcZ1p0N0b0ZB0dICAD53DRo8qzMLnYeFXWhH\ncNrpp+toKUV\/Mok+l5weLitDW12dcoEI62pBPr7G7d\/v7RxU2duLSsFufSI8+sgjyOVymDx3Lvos\nC3YmgxMPHvQszj97+GFMnT8flmV5FuSfPfywT59cLocZ11+PKQcPorG3l1baSJciiiiiiL8bUGPh\nEdvGH+vr3eR8+oe33eYbk7\/5rW8BAPaVl2NzdTU2Ll8OALjsm9\/0id3Q2IhEIoEtq1Z59ekxnMcN\nJs2ZE8hjj7ePHcu1LrPyRfV5x7K6Jvki2TIUkov803nnofzw4UA6z1WDHcu9GfIJEwYSOW4ZOgs3\nRWXYGQpeObaMaDMd+gOH\/T1pzhx8Zts2n5x3x46F4zjYWF+PQ7aN0htu8H0gkvVMSboB0QMM5KNo\nVLrEYtKcOV4UAx5hjtPaGBayL1hZ2YKBLBJsaUH1\/v0oZ3xqZC4bBKKvWd6xZVk49bTTjNXsT6Vw\nuLwcO5l4yCTgvIoU89J4dXa5v8fPmoU97qLJ0QcOoO7wYd9GJCKQUEY\/\/9nPMGXePBxKpfCX6mqc\nxExD0RZkogchyyTfR5iLKKKIIj7JIP21ZaE0m8Vn9u3DH1ziDMDrO4nbBgGJvsHiSCKBP9TXI5FI\nYPPKlUhQvsk8vkFms0VchBwfrKxE1w9\/yKgedB9R+RyHGf9p2SoCrrJ4R9XFBL979lk0XX01Zrz3\nni9d5KpBQHY77qEttAXwY2YxVO4e5f39oKm5z1XIoTR66KGHkHCDOicSCe83WlqQSCQwob0dKZfV\nE9JM9vGmwbMyk9+mlmbZ15zsSy5KWsGxdCkAoHHXLtgCgqhreWYfKFOiTEjyLnfajN6NSfSw8kiw\n6otQRLbZuo7jYOLs2d7vSe3tqON8GfPwclMTyjMZjzi\/M3o0juvoQJXr0\/yTdesADHT6x7W3BxYR\nFq3MRRRRRBEuqPHxrYYGLtH9Z2oDKLJr66YVKzxL89ujRnllt6xa5dVNcKJysbLZ8flIaSna6uoA\nd2Mxth59LCKzKl9nVZqMj4Rx+ZDJLBR4xBngW5xpP+a9TU35RAVh1knXsSLzysVhaQaAU771LR+3\neHfsWPRbFrbW1uZdOBcv9izNjuPgiiuuACAgzTRxJjczsWwZGru6MNKdRrcsK2DeBoBf\/+pXwgeM\nJcm6pJmXF\/XBF5UZVEQgz+wDoEuWCUne7T78O++5x5OjWkQoa1\/0W2aZZh92Uf1Jc+b48iZ1dKBe\ng0i\/M3q016HThNlxHBzf0VEkzEUUUUQROqDGyg2NjUriTI5pwsxz0+SN4+z\/jG2ju6wMXVVVvt38\nTLhBWLcNnTqiNnUgcj0dDOgQZ97CP8dxADfutQhhSLMOZyDHMh7BK8cjzRNnz8Znt2\/3yX594kTs\nrKpCbvFi3+6X4UhzIgGrtRWNXV2o7O0NNAbkCTMgfoDY1bC6fkW8PNVXpghhH+6CQoM877r33kCa\nzhaZ\/akUNk+d6h3TlmQClZ+RKE\/0Vagi31G+FB3H8Xbs+9zOnUJ9WbwzerQnK0CYi2S5iCKKKEIN\nd8x8q6EBPckkSgCUOI6PNBNEJcy9qRT2uCHNSKxlljfwjoMqi8vo8oEwfENXnk75QkFGnOlABbQf\ns5NOK10mhgtppsuz8h3HwQVf\/zpKqAWt\/\/XpT+eJMkWaCXEmpNnY+XhfVZXn28xC5Ts8HMD6UkVF\nLHJuugnO\/\/k\/3pdcE8eCT\/Z433XvvVpk+fCIEdg+YYJnSfb0df\/zHlCZ\/xDtw8X6aLGyeHJIGv2M\n0McimTw9Nq1YkT9wp\/V0yDPtz1wkzEUUUUQRIeD2lycBeKuxEe9XVyORSGBfSQkucMettdOn47jO\nTmPCfKSkBL0lJThYWekjyUEV\/GO4bExXldHhA2Hq0OVkstjyqjIy6Mhmsfu++wCBjzMAfHjccQE\/\nZksij9YlLl\/kuGTx5PxlzBiuAVgqx8jSbFmwWlvxtd\/\/PiDol0895T1IhbA0y36r8niIOi1SsI+D\npUvhOA4qDh7EyM5OL5n3NciiP5VCz4gR2N3UFCDLLEQWYTpft57MUi2yHOvI4v0mX5Xsl+a0BQsw\nqaMDDT09XL03NDYil8vhi3S88SJhLqKIIoqIhDVr1iCxbBku\/\/BD3D9jBk50F1+zJJklzJsbGwfy\nKB9lU6s0W5bNE5XRSRdBNAMuQli+EcaKLYNoXBdZnN\/71KcGwstRfsw6JFbHYqz6LcrXsTTTZUW8\nYtKcOQHS\/POf\/SywS7CRpVnHevxLzS2yw8jmwXTaI0yZQtaXwXF9tg61tOBQTQ1Oef55ZZ2eESOw\nfeJEP1HWmB7RtSyzdXlWZ5E82sIsO6bLk5eA\/k3aY699Lpfz0rbW1mJLTQ0cx8H\/aGtDKTXtQu9I\nVSTLRRRRRBHx4Morr8Ray8LalhYc09UFYICI0oR04\/LlPiMcKccDPcbwNjnh5elanGn96Lp0OV2O\nobIO89o1QaFmxtlxmuwgyMZtPu7\/\/b88aTaIxUy3FZe1uVDYsmoVJn7721prpAiMP394VubhcGFM\ndQijc5wPLwuWgJ7y\/PNSwtyfSqGzuhofHncctnM2ThFNRemUY\/N1vyx58kRuFyIrAe2uwZJk0fnQ\n5YisP48ahd82NWFfeTlPSa1zKaKIIoooQg3S76ZcIwZLmEWWYl7fT\/8mYwHPkswzwJC6bDnTc5Gd\nIw88YxGvrGosZa8da6CK0+WB1bHp6qu5m6Cc8sILPv1JfROIuIdIt8HE1tpaYR73A4x2z1i3bh0s\ny\/K5Z5CKJI3szEbwJ5ewefvIS6ZJRNtiipRj03XKqi44mz8YlmkVfGSZs0MPQX8qha3Tp2u9OLTV\nWWdLU1YPXpquG4aoXR3XDp2pF7oDIWnTFy6E4zh4b+RIHNvZGSg7trsb49n95ofBx14RRRRRxNGM\ntWvX4oorr4wk44nHH\/cd01xB5dYpSue5RMjGf5M8EUxIelQjXJy8pOnqq33jrmhxoMqNggcZ2Rfl\nydJkHIGtq+Oe4TgOPrV7t29B4MM\/\/aknl7hqhFoIyBJmGhNnz\/a2xiwUwrpzqGQCQ\/PVo0uWAaCz\nuhp7x47FrnvvheNG26hva0OJYFHm2GuuAZCPliGakmEhcrug82XuHOzDypPHszjLXDrofMvyu2uQ\nbV0BwHHzx7i7VrLYNXIkdlZWwnEc\/MvevaShInEuoogiiggDt5+9IgZRX\/3a1wJpxO1Tx+2CV46d\ngeSBdfHQzdPRI46yMrAW9bAgUTIsy\/LFYp68cSNS1KL5U2bOxGuvvhq6neGMI8mkjzSzsN2djAFN\n0mxZFi79+tcD6U9+7nMY396OpKCxMF9qovpxQCYv6pSOCViSqGNdJiHnHMfxYlXud7fmHtnZiUpq\n5zsa46691ne84+67peRZRmZl02B0HZ0vUN7UmsgiTtrL5XKeRdnNCOhbk8ngb1VVOM61NluWhYMl\nJdjd2opjFi0CkA+FVCTORRRRRBGGCDkutldUoCSTQUk2q7XjKwB8+eKLAQTXTIlItMgdQkVgRYYz\nWZ6sTdKuSKZuWROEJdB0WLlsMom97qK\/XffeC3zvewGL88xTT\/WIs8yIxtNrOMDEzZTGt7\/97YE8\n2j2DFz0DyE9zkG2LaTz5uc\/BSiQwyY3RaFkWtt15J\/frTuS2IfsS1J2GEcnUkacqF5U8y26Siixv\neOklbVloaYHjOKhva0OpuwGNDrbfdZdSvsq9g+e2oZp2kf3nyZm2YAG3DZ7c96qqcKz7EUHS36+q\ngpNO45hFi3xTNt4CwWH2chdRRBFFDBsIxsF95eXYUlMjHM9FY7JlWZiwfz8q3JlSXSJNb56mcq0I\n426hwy9k9U1lytqIAzJST8LYAn7CTIxypAzPVYO2OOsY4eJyz9DhGjL3DJrLkJ2H+xMJTNu3z7cY\n8GcPP+zb3OQ73\/mOl6dFmv+\/f\/3XwAk8+cQTeQGtrRjd0YGyvj7vBhEiNlSkmVfX9CE3SSfQ\/YqJ\nlSyzZVzyPLKzE1XuSmYdkPo0iWbblukh8ivi1RH5OpOyU+fPF1q5dX6LSDPZxYglzp7VOV9BeI5F\nFFFEEZ8oSMa8340ZIxzHP7j1Vhx7ww2+NAD48LbbvGPCL6YvXOgrM2XXLo9Mi\/D0r3\/tk+FXWcwp\nZO4WKqMbyQvLJeLgIGHBzg6rCDNd9sRLL0X9vn0BmYQ4ywgx7zcNkUEuLtLMhqjlkeZNDQ2Y0taG\nf9yxw9feT3\/yEy5pDrhn0A+OaGqjj\/LvQDqNPS0tGN3RgXLX\/2XCddcV3L\/ZBHE9rFGnGkzcMEza\n85VLp2EB6AbQ5fo+j+zsRGlfn9QCTc57\/KxZwjLknvIeUJ7\/MptO\/tPuFlPcDUpYuezUDztV9n51\ntXe+M66\/PlDmg1tvxTGLFnlpEw4fxja3DMkjeHvUqAGrc9Fdo4giiigiQJiP2Db6bBvv19e72fm+\n1GppwTEHD3qE8oNbbwUceeQjYGAs2Lh8ua+c5a5Vmbxzp5A8X3DhhQCAZ55+Wkh2Wf4i4zR0mk4Z\nFcK4ioQtqyuPQIcwAwPX6y+PPYbPn38+ygVh2XTcNOJG1DYnzZkDB\/kt2oF8zHCWNIvgI826Svz6\nkUcCser21tV5FmcTxPVwqF6YwQbb9pdOOYVbLpNKYeuMGR5ZtiBfbcpCVo7sqtQNoMtxANcHGgAa\n2tpQyrlXLMmlMeG667Ta1fny9NIkbdPH\/YkEUrkcPqytRW7xYm9nwxnXX+917uSe8z78RmQyvuMP\nbr11oL6LDY2NcBwHJxWJcxFFFPFJBQ9eBw0AACAASURBVDV2HbFtdKZS2Ozu\/AfkrcX5YhYsABMO\nHxbOJLO\/j73hBq\/vDTabL0dI9CbLwrQFCzB2715U9PQgxXHhOP+CCwAAzz7zDFcmOybQaaxubD3v\nHA24he5stA434ZF+kTxd6BJmFr995pnATsQy\/+ZCkOioMnn1M2TmIZ0GOOv2eAhYmtkbxXPNCCCd\nBlpbsbeuDmPb2pDK5TDhuusCU\/1xQZcQmxLnQpB3XbJMwHupTEioVC\/XPcFxHLQBPhJde+AAKqgv\nSRl5VuWL8njpvLSsbcNxHBxOpbC3ogIgrhTunvfkw+KYRYu4iwEty\/I6fvo6jlmyBLtaW306fXjb\nbZhx\/fVeXcdxsGbaNFxZJM5FFFHEJw2WhSOJBGBZ+GN9vUcaE8SqzBgl0NKCimzW19\/yLLoi4kz6\nbnaTEnK8acUKbHLTpy1YgEk7diDV3x8g0Oedfz4A4Llnn+W2yeMCqvFeZ9ZZx6VDp76qfR2SLuMD\nNFkG9AkzTYZfe\/VVKXHW0SNMubDQkb+7thZwXTa6SkowUsPoa7y5yS8ee4ybTqyaO92tMQG\/ZRIY\nfisp4wTvi9SEMMusy6Kv3Sh6WpaVf1ncv45bb8W2MWOwbcwYHCov9\/76SkuRTSa9aQwd3eg8nfRM\nIoHekhJsrK\/Hxvp6bK2txdbbbsPem2\/O69fcHNiRiO28fb\/dsrT\/nGVZqO7v950\/+fvo9tsHBodE\nAsd3dWHt9Ol44IEHNK9qEUUUUcRRDrev\/EN9Pf7U0OBb30T6UpYkVrsumT7XDCDwe6CJ\/G\/iHicy\npLDufJZlYdOKFVj\/yCP4aPJkHKyq4p7Cueedh3PPO0\/qHkG3KTL66JJR9vxMwZ63b3wWlJPpwdMl\nLGGm5RLwNj8hRNrEZWIoueCkOXMAwMdpHMdBV2mpVn1uyLkwJ0QsgACwrakJE3bvBjDg31wIH504\n\/YOi6MarKyLMPSNG4N3nnvPpZtIOa1U1hcjK6ziO9wK1s5Vc32iHqT+2rQ0Z20ZZXx+yyaRPfiaR\nCDyUbSNHAgCmtLWht6QEu6qrBzrHJUu854feRps+ps+b1+nS94G3kY7sOfjwttu8BYKJRAIndHfj\nbzffjLWJhBfUvIgiiiji7xKWhQ2NjZ5VmeeKwftfz8TFZ39nbNvbJdDfnMV11eCVY\/vtzStXYjPy\nC8anbdniiyVMcM655+J5apyVjQE8Fw4WMst5FG5jYqnWde2g8+mQcgDQU1GBA3V1+QMNwsxi1733\nYvTFF6NKEOJWB1F5S1RZBNvr6wd4j+Ng18iRGEsFT\/jWv\/0bfrJuXWDxqNSn+V8vu8xMi3Q6H70B\nwJGSEpRJFgYOtc9xHDAhy5lUChteftk7juPBEX1N69bnyeKWcd06AHjE1nEc7JDI4+3kR9wdNtHE\nneQzlgWR5QHIT+8Rt4z3Ro7EcV1dPv3JQ04\/Y+T31P\/9v7H5hz8MnG8ulwu4ahzf1YUPbr4ZD1r5\nGNJXRtz1qogiiihiuGHDqFGwRo1CgrFyEsLMWytCUMIhcj6CS0Uy4uUfs2iR1w6vLXo8YMnLphUr\nsNmy8MXLLkN1Z2fgvM4591wAwAvPP+9L1\/EV5oGng0imCKIypr7OKpmeddnNo63LluvmaAJ6DP7j\nU08FFgbOPPVUvPrKK0YyWbmDAZ6V2RSBJ0B2Ao89+qhaovv1sreuzqcY66rBthmFRIZ50GiEIe+m\n1mVCmKOeq45evCke3S811Re3DkQdiEwuz8LAI89sZyeqJ\/q9pbqam05PRdJpx3Z2wl62DKlUCg8+\n+GDRZaOIIor4u8GGUaO4llfaf9m27cCYYlkWJtx4o68O+5vXN79E3AKoNDJrKCOeMnL11s9\/jveP\nOQb9qRQ3\/+xzzgmk8azLKo5AdDCxespcLnRl6NSh9WLdMXoqKgLuGFE5z2+feQY9I0b48k897TQt\nXYcCbLv95FyomNSbVqzAEQ6ZZusKfZqNrcw0XEV2Uf7NQJ44D6UvS1xtsw\/cl045hUuYM6kUNp5w\nAt597rnQZBmIprds+kenk+CVoztFEyJsuviB14mSMHIZ28Z7VVWYdugQt1Mix+zilSZ3pTerP\/lN\n+zeTv+O6umC1tsK2bZSUlBTJcxFFFHFUY+3atbjnhBOQTSY9AwHp7zYuX+7bq4HtD8nfDtevmByz\nfs+0yyZJO8t12+xx2yU49oYbtAwtvLHHcRxsXrkSLz31FA6Xl3PPlybOPIMMK58tqypHp5uQZJGM\nMGP+2Guu8UfHsG3smjAhkjuGDNsnTtQuG9WirHOvVPnEygwAe2pruWX6OKSZ3g0QYEizTIlHH3lE\nqlAA7pT+NncfcwKZxVkF04dQ52GPKlPljrHznntif1jC1pcRYRlUX+MiuTKSzHZcMosySSPB8gF4\nfnIljD4fUrtTsbIsy\/IWrrCb+NC\/Ny5fHhgg6DKEPD\/00ENYs2aN5MoVUUQRRQwfPPDAA3jwwQeR\nWLYMnz5wACWuywHb99m2LewfWSIN8A0QlmUBzc3oZ9aXvP+jH+HjigocdgkKqUfHzqfTAT2CZFkW\nXn\/8cV8EDRpnn3OOkITzZKm4AW\/MikoOVbqJMPaaa3zHWdvGnjFj8gR8yRI4S5YE6oS1NhNSv\/Oe\ne9BJ9ktwcdrppxvLHGx4HhCcj4iukhJlfePoGUZwoxgcYr7+ZBtomCLKdEYhCDOxLr\/10kuRyXKc\nhJlF2E5BBVPLs+xLnk6nF\/5ZloX3qqqQ4XTY5JmTdeqk02fT6d8kVihJO+bAASSWLfMNGIlEAqlU\nqkieiyiiiGENQpaTySRs28bEw4dRCr972ke33+6RYkDcN5LfTUx8ZrYvJ8e9HLeJxE03YVtlJXqY\nPDKTKIKOAQbIh5774NhjA2XPOvtsnHX22b403jgX1qhEy4yDPKvkjL3mmgBhPjxiBPYIdvhj5Zlw\nIB5v+sOTTwbK8YjzUHoYAH5f5g\/GjeOWcRwHO91gBXQaCyOf5lBobkZ7dTW2Mb5McRLnsOA9RCLo\nEua3XnoJO++5J7JOUWHqwxznF7hMlqgt3pc6+c9O3b3vBtovaW4WWpVFaZZlwXLjU6sGBWJ1IWkT\nurs9Nw0ZeS66bhRRRBHDAWvWrPGR5UQigYbmZlS6M3WkHyMuGUDQD1f0l6KiHHGtzC72jBgRKOM4\nDqzmZmyrqMBh11WD5JMNp2RugKKxiB5rtqxaxQ2RBiBAnEk7IllsObpt2XhdKKszjyxnbRs7x4\/P\nu2OQcLISebr8R1VGdI2HC2jdd9TXo6K3Fw5nu3BdcEPOyRqXESY631e2uRloacG2MWMwZu9eJLNZ\nAHniTDZACWP5BagXMERdVndWLg8id4yumhr88amnIrWva80l5U3zVA+HrBMQXR+eewXd2ams3by9\n5+l69JSdr9OlpptIeh+VT4NExSC6jTp0CHs5zynvt2VZ+My2bX4Fdfz9v\/vdgd9D\/JVdRBFFfHLw\nwAMPeASZ\/Afy\/WJDczPqjxzx9aVkHQeBzm9yLMoXjcmWZeG4738f7\/\/oR\/mEdBrbW1sx4dAhjKA2\nLCFRjD66\/XZffbpflrVBsGXVKmwBfzHgWWefjZdefDGQLkJYjqGjJymnkgMA4669NpCXtW3sGjcO\niVzO2HeZHad1PgZo7LznHkw++2xf6L\/TTj8dr6xf75NjasEniFqHbJndq+F6weLb3\/kOIPNpJiG1\nvvVv\/+YrpOPnoQRZHDhqFI5Q8uKyOMdtIed9hUUhzLIvdpJvApGssIRZJF9VV0dvtnOVWZ7pPGJh\nZq3MSKe9zpdGxl3lTcsl1hRRe+zvSy69FJdceiku\/frXcenXv45\/+Phj5fkpYVn+vyKKKKKImEGs\nyqlUyuvnSOQLQqAbjhzhLu4DxBZjbnprK8pdksvrU3197k03cct45dJpbHctzqy86QsX+s5RZlji\njYHkNxt2juDMs84KlBXJlUGX8PIs8Ww7or9x114bIMxZ2\/bcMRKLF8ey2E\/H+szq\/5sXXgiUGQ7+\nzRNnz\/Z+k8V\/xIUzLGfUsjQ\/89BDQudnEyuvs2QJrNZW7K2vx6j9+704zrTFebBgSlJFhHnjCSdI\n3TFUlvk4IboXPGuuTAYN3a9OUo4bn5kpQ\/JY8kz0dxyHuyjk\/epqgFnQwNOPjtPMK1fV1+dZmr\/y\n1a9Kz6sgoO9R0QpdRBFFRMCaNWtg2zaSVEQKet0G6Q8Tra0BIw1tZVZZldljOu2j229HgiGsiUTC\nO+5PJLibnHiW45tuwo6lSzH+0CH0JJOo7+31ykxfuNBndWbHOd2x\/IXnn+danM886yzP4syb8dXl\nOLJyYa3UPpJMycjaNo6UlnquGCQnLKcIawWm0TNihC92c1jo6GGqa3d5uTfWRj1PI\/cMGqEfJHcD\nlL319Rjd3o5Sd6\/v8bNmYcfdd4d+uEx0MoFlWThl5sxAOvFfVtXloRBO8TILs+40kMwtQ2QNZn\/z\nyLOoDdGLyrMYfFBdDau5Wdg5WJaFHbfcAkshx7IsnLBxI07UJMt9ySRKqGnD7tJSdJeVYTe1jSt7\nDT61ezdKXBckJYoEuogiijAEccGwLAvJZJK7A6pHlhMJYOlS1PX0+AgyIbq6ZJk3lrCEmybKJN1x\nHPSmUrAyGc8PmuwG6JPX3IztAI7cfDPay8sxvrvb57JBrM4f3X67sasouRYvvvAC15+ZEGeRFTgM\n34kih+eCAQyQ5Q5iNaV20iVtFoJf6OCdp58OxGo+7fTTsZ7a1C0u6JwjsTJnbBv7q6ry42tzc+Rx\nNkCas7qDvQTKB8Mlzm0NDWjcty9AnAvatiHiJMyFepjDuF7o1JVNVwFyCzbPAiwiyHQ+8T2m8\/oT\nCW9Khc7jEWJaFt15nbBxo1BXFofKyrDZDddDsHH5ckydP3+gLcfBxvp65BYvDpzfRvf39IULfT7f\n5PfYri44AKr6+lBFbwFL9C+S5yKKKIKDNWvWeAuPAfiiXbBWUtqXGYmEz5eZzvfKUJBZlh3HUW6f\nzfa\/u5ctQ9PixUj19UlJpWVZKFu8GGhpwfbKSliWhRkdHb6+fsb11wf8sEXglXnxhRdw8le+ErCK\nnnnWWXjZjXoVhfDquHKIyojIMpCPiuGRZc5CNvq6huEacRDuD487DjPeey+SjLixo6EBcBzf4j8R\nNi5fjn9SrFmynKDJLlDov37+c++loV9E30uJoE8Um0anA4DlThcR4kzn8azOopeMB9F2l6p6NGae\nemog7WgizCZtsu4SulMkNClU1SUkW5RPLAls\/ge33hqQzbpvsOXIPbjoy1+Wn4SLQ2VlOFRejrba\nWu7iE4JpCxZ4xz2pFHbccouXJ3JNIb9zuRxmXH994Lo5joN\/2bvXr1CROBdRRBEu1q5dG4jYw5Ik\nkscjpfXpNOp6erx0OjIQgc74So7H3nADyjMZ75juM0UGE6u1FcccOOCTF7A2M0gsWwYAGN\/V5flQ\ns2DPRec3APzLN76BkYw+APCyO76b8A2daymqIyPKAHCktBT7GhryBwrix7v2YRDFReKfL7gg8EGy\nntoRWSWHd8ymydxAHcfxNtLL2Da219fn013XTpqH8P4CG\/uxFFmXNAP+r1oRaSb\/tUizlV9QAAC1\nBw6g0n2pCVhfYdOHWPbgqh7qOAkzUBj\/5Sj5srK8h1RWh2dNVZVny7ELPgDgkG1j+w9+wJV3zKJF\nPhkf3nabL1+HLB8uL8eWsWMBDMRlZqf1WEyZN893\/BEJ7wPxOUYi0EXyXEQRn0g88MADgY1FeMSY\ntTDzxtjp7e2+tE0rVviOaajGRsuy0HfzzTie6qdEll+2P21avBhV7syyZVk+Qwfbvk9eSwssANMZ\nqzONzStXCvWlf9PHk+fOxbS\/\/jVQ5+WXXlISZJ3rJIJOAISsbWM32RzOYIHfYBFnGdllFwGGJc28\nMRSQk2ZybR3HwdbRo\/P56bRv7CX5juMgl8v52lGR5tA+zXHAcRxY7sPQ0dICy7KQzGQ8dw3yBRbW\nZSOsq8YnmTATyF48kVVZ1+2DLTttwYJAfn8i4fNRlrl20KHmLrzoImm7782YMeBG4RJlAL7tXtnp\nLrr9zStXem4ajuNgXFcXdlHTo7zrwXvxbdv22mcJ9G+bmgYINNGhSJ6LKOITAWJVTqVS0t33LCsf\nspO2OtP55PfYri7vNwCPMKvIsmzsJGs2RASS5ypgWRb2VFR4u7KykI7V6TSs1lZsrKtDn21jRnu7\nF7qW1KPd5+iPAp4VnmDr6tWovewy1LW1+dLPOPNMIXHW5RQs\/9AlyplkUtuyrNNuocEbmzurq1F1\n8KB3fPoZZxj7NusY4GR5YULM6UBpaf7Zww\/7FhTQDx9raSa\/dS3NbD6xOtcdOIAR7m5DBKJFgjrT\nJSb1eIRZFSFDJm84E2ZeeZ0HUkSaZQ+5qBxrYSZ5PAsEyWddMz6srcWFGzYI9QaAg1VV2DV6tHe8\nsb4+H82FuW8614O1Nm9qaAhsUyqyvvPSyX\/iA82WOVhSgp2lpbjiww+l51hEEUUMc2iSmZ\/+5Ce+\n8TZfNWhhHhDLH28Ty5Zh6r59vnIyKzMvjWc8sFpbMW3\/fi+duGcoyVpLCyYfPOjbGEXU1wu5g7s5\nFQBMOnDAkyWCZVk+KzTv\/M4480xuXUKcw7hfTLjuOmUZApG\/chSILPK60OEasjInn3OOL3bz+pdf\nNrI0izgDu5aKziMfJhnbxo6GhryO7tjMWpqJhZkdcyO7Z9CkmTdFxHuwZaSZpLHlvXRqt7bxO3cG\n6rFWZx3SzGuTh+FsYdZ5AUwIcJjypIzqoZa1Q9fnuWQAeVcLXhvkOtMblRzz\/vtSfQ9WVeHNhx8G\n4LdEbKyvhyWJ16hKo63NmxoauC4avHq8aSU2jfbtJmX6LAubKivhuNNMl19+ufS8iyiiiGGECJa\/\nRx95xBUxMFbmmPBtolj0Y264AeX9\/bFYmX3keelSH2netGKFdDYQoPrBlhafbzOPNLNrkoT6uDPU\n9IeBrA6NLatW+cqJiPP6l1+WXg8TckzjSEkJ2lyLssUsdI8TYclzVNI89pprAuPzyxwuZUKaeW2S\nY9qP+UhJCdpGjvS5ZdDjLU2WaZm5XA6XffObrIK+w0juGWQagDcdQOcB+lMa3ldWayt2jBuHhn37\nUHrkiJc97tprQ7lrqKYs4iLMUYlyWAKu6rBYyL7WVG3w7rnueVuWNUAKqfSeZBLb3Yec1l30wqtW\n6HZWV+ONn\/40ryfVNtG1rqcHHZx0MGl0uqjjnNTRgY9bWwOWa7ae4ziBle50GpC\/L8RtY9qCBV7d\nUsfBcV1dOLxkCbbdfDPWrVvn3cMigS6iiGEKps94e9SoPMnr7ERpNouSbBalrpvB\/hEjUM+Jc\/v1\nb3wDAPCLxx4LGKNUximdmV7ZsSyNV1c2znrh6Jj8YxYtwoe33RZu1jidBiwLm1pa4DgOpu3fr801\nJs+d6zveeMIJXP\/mSXPmaMnTAU2U2QgYPuMhhaicguVicUBH1o6778YxZ5wRWb6OQY7+cNnZ2Jj\/\nQUW2IjDZs0IEJWkmLJwlFtokOCScJUtgLVvm+faM27HDywvr6yx6oeMgzGEfyDiuo2nboo+cKG3o\nXgvaf9myLPQnEthaXZ3XqblZSv4dJx+STkSY+1MpdFZV4e0HH\/TqiQgxb0pPdA4qAp2kphrpcrJj\nWrboem1cvtxnjbcsCxXZLI77\/vd9q87XrVvnvadFAl1EEcMEloUNjY2+fojERd5SU8MltB\/X1WFG\nWxsqKUMRwSWXXoonn3gi4McsJJUtLT4rM7eMYZqXLiHSwclrRr\/mZnTeeKNvQaBqHFSOk+k0EpaF\nzQDQ0uJZnjOJhNc\/68jfdOKJmPqXv\/jypv7lL9h04olKGSIcKSlBb0kJuqqqfETZ9D7E4WohklEo\nPnd4xAiMoD4Eia94oXCovLxgsgmU7hkP\/\/SnsKygW4YvcDrC+zWzLz53ysl12Wjcv99ndSbleeRZ\n9hDQ+oQlzEROlAdZ90GNSmhVZXXcNFRlRDoQMida7Le1ujoQg1k07XP+BRdw2+hPpbBl2rRAqDgW\ndLi4rtJStFHh4lRfs7x7RVsqelMp7Lr1VuG1k305i\/LIVzGtt+M4Ax8abgecy+W4K4KvuOIK4TkV\nUUQRhcHatWthtbbiuM5OAMHx0LcAmSbU7ng3df58TGxvR+WRI76NlWg88fjjQsukl0aRR8uyAtEl\nTIhSoKwrm3dOWvJaWjC9o8OXxkZA0iHTIjcOXx9LuXzWHDqEkUeOIJnNSmWzxBmAkjgTctxZWTnA\nozgzpzKo8uOwFuvKEBlITa3ApzPWZpY088ZD1ZhI5xErc08qhb11dfmMdDowJtL1ee4ZZNz85re+\nxZ6I79CYNAP+0HM6pJkuxyvL+0\/LAeD5LgF+qzMpp+vrTOexu9cQvP7aa8K6gNrVQwcm9XUezCiy\ndOSHJc2A35eYlOtPJLC1pka66IGUPe\/884VlOqurPZ9lApGFl9ajs6TER5p57fLuEX2e9IJAx3Gw\nubGRG3SePQ5DoNm2+hMJbKmuDvhSE38tunMoEugiiigs6DjKTYsXo9q18NLjGr1YjmdQ4o2XU+bN\nw4T9+1Hb3R1o86knn\/R+86zJtYsXo5ay8m1euVJuPWYgG+es1lafHzHxaVbNYNL5kxYtCsz4kdB1\nqjFW+cHAaZvkkYAD5Ljm0CFU9vaiu6zMV\/Yf33knUP+vn\/2s95sQNE8D1\/gTlRjrcIM4XDYKXYbk\nfencc30LAgE\/cWZliFxHecY0duEfAM+PmS7PkmYeec7lcpi2YAE+v3s3eyK+w9hCzoleGJ0vJ9lL\n4qW7vktoaRH6OgP6LhsiwvzqK6\/A0vjCioK4CPNgIMo1oEkqLa+9vBzt5eUAE3GCV\/bc887j5vWn\nUtg6fXq+k6V0Y\/WlfYhZ2bzOlWfdELlqbF650iOzlmVhVHc32ixxyDq6o2fL5DguHjToUHcAUOI4\nmHLwILYuW+aL3GHbNhzH8f6TzmDdunWeHkUSXUQR0bB27VqfcSiZTMKyLEy48UaMyGYBJgzcxuXL\nYYE\/C0vAMyxtXb0aljujxRLni7\/yFfzyqad8dWgj00h3fBQRTBWBZvtHWflpCxZwFwPKxrqt1dUY\ndegQqji7BMrIsC4SiUSgX\/W4xIBQHABwgCO\/65JLApufnPCHP+CV9euVusqg4kU6vCnqLPdg4o3n\nngtYm+PAhOuug4M8Yd7Z2Ogjt1Fn32VQWprXPfSQ1yGIQs\/xHng2TbYallePTffVcadbRnZ2oqqr\ni\/uAyULEsYG3CV595RXtFyCspTnMCxYmz6R8mC9K9guOzueRZSDvX7a1tjYQno0nX0SWgbx1ecf4\n8djK2QGQlsVeazriBeueIbNOyEBcNEg9siKb1YVN07E288pMnT\/fly+6prwoHTSJZi3TAIpEuogi\nJHjwwQd9YxE7HgIDkX1IGWBgxzrReKaabSX\/z\/7qV7nuGr\/+1a8CaVZrK6ZQsYe3rFolHHt0SDGv\nH2Nd7khkDp1pfU92SwsmUSHoAATc7HQszvSxrtFD55hH9l595RWlHirolC+kxXkwLc2A3NrMjnO8\ncY\/9T0fK2NXYCIfkUS6LbD1aNjsTS9JUkTMAQL7XNOfkdfJ4ZvQwN1fkGoB0Gkin0VVVhR3jxqFz\n5MhA3bHXXKPcnpIG70UQYTgQ5uEC+sNp2oIFXN9lYIAwi9wxaDkiwpxJpbDxhBPQNm4cPqb833gd\nHxvwX9QWW1\/0Mcj748qkpv54bdH60Tt9sQt76HOgf29ascKXlnIcTD5wAPbNN\/vk2LbtHdu27ZW3\nbRvJZBKpVArJZNL3t27dOjz00EN48MEHsXbtWu61K6KITwrWrl2Lhx56CA899BDWrVsH27Z97w85\n9t7jZcsCfcTmlSv9ZTT\/89Ke+8Uv0J8MTg5feNFFvjq8vkRkuWXriOqp+j9aJu2+yeYFZDc35930\nKExfuFDZDu88ZOdpCiLrlfXrkUmlfHmiWWoTDMWsdSGg235nVZWyjK5Rj46UsYtEygCkYV9FcllS\n3cncax60omdks1nfS6D6MhXJUZU3nrZwL1JXa2t+ZSqC\/s40cd5x991cK7MJYQ6LuB\/uuF66OL44\n2c0+6HPtSaWwpbYWqRtv9OWLZJ5z7rnc9J4RI7Bz8mRfmsz1gv3Nlkm6cU5FVgkeoea1s3X1akye\nO9fLG79\/P7YL6vBk0fqx+oh88rasWuW75inHyYe9c0M6sedMu2sQkDivJAwU7wucuHTQftJXXXVV\nQKciijjaQT4SacKZTCa5ZJLA9766m3bQ5TatWOG5ZEDjvygNgBcx4\/knnsBp3\/gGKnp6fPkXXHgh\nnnn6aa9u04EDxgSSbVvVd7F1eYYEXn\/Kq99ZWopqN5qGDkTtycrrjHU8GW88\/3yAN5x62mk+3qDD\nb0yhK1M0xg0GdNv870ce0XLRUBloacJMImU4gG+mVaWTKD+bzaJKsFslDSVp\/s7ll2PdQw95jbEv\nD3kY6f+sgnE8TFI5xHrp+jsDQfIM8N0yhith1n0YdWXzyFRUsGSZRiaRwMd1dUA6jRLOrAPbiYnI\nciaVwsfHHEMqAgA+aGiALRhoROc2bcECn+tRueDl4H0csu3Q58DmpZhNB0SDjUwW7YfHkmrye8uq\nVZg8d+5Au46DSYsWBVxWeO+siETT50+TZ5pYk\/B2JGLHVd\/9bvAisjgKZkyK+OSA9UcG4Lkg8iys\n5D\/b19J9xZiuLqQcx+tjRNZPE6IsKvPqo49iyrx5OP6jj3zlz7\/gAjz7zDNASwvKqP6NfByzUI3N\nKqNEd1mZ5zdtIoMdh6zmZrS1tGAEtbvf9IULpW4apmMquQa8OL06snorKlB26JBRmyrEYUikofth\noIu45bFba9Ph53SszDRhztg22qur8wfp9KCOMUYLAQvxNcWCfFGHAkOeq7q6UNXVBYC\/GcZwJcyF\nlmtal32g2aDwNDyyDPjC7fA6zdhCUQAAIABJREFUTZJ+9jnnBOXQZJmq15NKIUnt8sOej+6HwaHy\ncuV10CHJ3PNrafFWUutYa9h0lriL3jti5aaRWLYsEMGDbYvnM8a7Rzxfs4DPlw5o3YsEuohBxJo1\nawLuCixBJhDtqsfmkXwaFdms7znfsmqV5\/uotFJL5CYSCWSp8Gjk\/9bVqzHpkkswgrE4n3f++Xju\n5JONLMqAfPaYZzEGgH1VVRhJ+U2LzoFOo+WwaVtrajC9vd2rM33hwkAoO5Oxi2fAI8RZJEfU1274\n1a+U1uZCoRDEOW5CzIIn+93HHw+9IJAs+gPg+THDcfLjLGc84+nAuvvKysoQJM3U1zKNTCaDJOVP\nxVq+eA8oICceptCuz7htnCaIucy6buggykurC9H0lyy\/kCBtewSNQ0x5ZJkng65z1tlnc9sjhHnj\n8uU+H+lMIoGdrhuOCeHlgbcIkIBnWZFd\/62rVwt3jdIlyqJ0Xtu8QcxxHKRyOdT19OAAY91hz4+2\ntrDWaFHHQnYliwyiS5E8FxEzeAQ5lUpJrccEKgJNg60\/df78wJjJI8UmRFnWHsFrv\/gFNxwnW27r\n6tVKEi3r33gEVyVDVoZruW5uBlpa0FVaipFHjniyaIuzzniqU8bbmdAQr6xfHztxLoQhstCEOAoO\nl5f7PvTOOPNMvPjCC9yyvFkBjzADXMMU77x13DWy7q6cOtCyNMturMw1Q1dOwcg0IW8c0vzR8cf7\njgmBtiz+ZimmiOtFUBG6QkO2hahlWcjYNj6urc0nKELIkTqO40gJ8ytPPw3HCW6I0pNKBYLF0wjT\nocsGMVHno7onDd3d2M8ZZKIQaJLHtTjNmeMd1x4+jIPUlt4iawsNGYn+2iWXBM6fRldpKT5saOB2\nXH2WhcO2jePb27G9osJPxBsbcRLHSlVEETp44IEHAlGcWILMkmIa9DugQ5Dp3yK55PeWVau8MJgi\n8swey\/onGWl\/\/rnnAq5t57zxBj449litc5K1Ker76PRsMomkSzimzp\/vRdCQtSci4MRNo4rxbdbV\n1wS6nIUFz02DEOdCzsQPxiw\/D3ET8G0TJuDYDz4wqkPcMjK2jV2jRgGO423spaubyOosOpZB2z3D\nRDnZYC9L08kzdd\/g+jGfdRZqOzp82zvSCGOBjguyabKoMnXTZUSZIGPb6CotxYGbb\/ashjyNeW2I\nCHNvRQXeeOIJAHkLA2296bcstN1yC7cNAh75FF1H9hkSldf5aGEtMUnqqzUOoizLsywLH99xh++e\nNXV0YA\/HN1tkueZdi6989auB86TRXlGBj+vq8jIBX4xW4soxfeFClGaz2F1djSSjBwC809QEAHj\/\nRz\/y6hACX1xw+HcO9r2UjC88glxSUqJFkFkLsw4ppn+r8ulNt0i6LHIETy9eOfKfWMBE1mYAXOJ8\nzPvvS4mzSj+SxuvvPD\/l5mZkFi3y9Xe67QnLpNPY2NKCafv3e0nTFiyQummYjJVsPVNCyHPTGCzE\nTZyjEuIwdXfcfTcmXHRRwK2IJ5td9Le\/uprrkmGiGy+dvGOnfe97KvUBaJJm+gUmUxuWZUXzP9ZE\nlAeF93C\/sn49LMtCR0sLOlwLKbtRCg02bJ0s\/nNUqIheIa3MukS5u6wM+yorYS9e7KXLXj72XM44\n80xuOdEUDcG2+nqhhULUbtjysjqqMpZloby\/H5Zr7aUhWmRI68mdumTAe07oe1Ceyfj8qkWycpwI\nIo7j4OKvfCXQZl8yiffGjcP\/2LoV\/z1pkm8QcxzH89+k9d+8cqWPKE9fuDBQZn9ZGVK33OJdK3IN\n6M1YeH\/f1VmAWMTwBK9\/syysXbMmQIIty0JpaamS+LKk0oQg88qrypL\/o5koFTJXCNFYKbOUysZX\nuk5\/KhWIg3vM++\/jw+OOk5JzFWTlLMvCrpoaLx40\/cEg63OV41s6jb\/dfDOO37vXyyObp5jozrbH\nqydaHChD3G4aJhxnqCzOcSIl2BqeHitoH+aDlZX5sMK5XGBMo58z0\/tI6hAZgcgZgmdYizQTvyIy\nYOlaw3iDu+5ND2uJJlA6nFN+t\/vczVIAYMyePbAF\/i2WZQVIdFyW6EJYmEWYOHu2dtmMbaM3lcI+\nEmcxnYatMW3Hg4gwv\/Tiiz4LMrs5SiaR8N0vHeLKHvsGGMWiHp022DKsX7NlWbAE1myRfN7gqXN+\nuVwu0P749nbsoNw0WPAszBdceGHwJAEcKivDpqYmbFm5ElvgJ8lEFvv88t5Rsqshnd5w5Aiq+\/ux\n9eabve1PWT1Z1w9Cqkk66fiKhHp44f777w9Ygy3LwjGjRnnPwD\/v2eOVv+LKK\/HwT38qJbwiKzIv\nT6e+7LeMdBOUudtli+pGJcM6H9EA8OrTTwtn8EjfHNYiK9KFlNOxUptanktzOWxqaAhYnHnuHypZ\nUcqIwCPO7D0vpJFLhahW5ChQtbtpyhSfi8ZZZ5\/tM5rRFmZCmB1iYdaQr9KFHlNMfJkJ+KTZ4S8G\njAP0yxv2qykswSTbXwZAEbLd7uYUZLdBFXgbqJhao3XOJ+wLQD+AuiBEeX9VVf5rT7AhiQl4hDlT\nUoLXnnnGR5h55+ktMORAZG0VlQGArLvZh6yOqL5oEGMHj\/qDB7Ef4JZl5ZgOkmwZMgDT71Uym0V9\nZ6fnW83WZeWef8EFgXaAPGF+5dFHPaIs+mhWdU6kzS2rVsFxHO\/DyLIslAKY0dGBrsWLsfcHP\/DV\nVX288HY+ZLcMp8sNmdsHOY8hHEjjBCHEwMDzxz6HZWVlvmMgv2OeRS0o77NtlFADl23b3m+Rr7GK\nzKrcI8ISZDa9+sYbucRdh7DrtCWL8sDWsywLL734Ir548cUop9wOZ7z3HrZZ6lm00CSTSZsybx42\nr1wJQByyTqsdd2HgpoYGTN23z8sT+U0L9dPIM7U2i2TNPPVUvPbqq4FyOuf\/SbI277j7bhwrMKCN\nnzXL+71tzJiBDA4HMXHBkKUT6MRoBsDZRtvLGbgpGxobvRWsZEcktsOkLQnkmP3P1uGVo9NVHaUo\nn2dlZgmzVgdGbddd2teHMs3g6zoPNLFQ634AiG5TGFLMQ8YdrHbU1+cTFF91uuki63JvRQV+89RT\ngXTayuw4+W2iP2bidfIgu5+O4\/hCs3WXlWH\/j34klKXrzsGWpS34GdvGTnfwUA1SqvZEpJSnMzuL\n8HFTU8CCS\/\/mrb4HgP5kEh9MnIitq1dL9ZTpRk+38dLpLcG9di0rcL95AxqbJtKN1ZH9LdKTd17k\n2MiSLXqvhyl5vv\/++73fdJ\/OEmL2mC7PA0knLjok7bPbtwfK\/uKxx4T1ddsSWT9FsmQ6i9LGzZ\/v\n8+f9+I47pGOWKp3NY59xlWySxutzX2YWw5taInkfygRN11\/vxYW2LMsjzSzCuGyQMZgmzgCMXTVU\n9xLwx8fXlX3yOecgSfGC1159VVjPxDijg7CcwaRcmDyd8WDm+ef73IlefOEFzwCZsW3sZHb6441f\nqn6dTWdnJLPZrJc2bcECfIFdmC44Dy33jM+2t4OEUWcvCPFrJl8\/UazHvBdTZX1lrdY6hFkbJHQd\ngC5mwQch0iJfaBVoC3WhvxpZ+YQg95aUYH9VFaq7u3GwshJIpwML7WTWWx6poNNF1uXeigq88+ij\ngTzWLcOyLGxbvtzTycRCQqdPmTfPR172K7b0FA0QOh0vQZITW5WVp2qPzteVIbJusAOu4zjC7coP\njByJt37+83xZqj1TEsCzFtO6kQ1aaGxvaAhYqGjrI0ljy4g6VTZPBB1LEzmfn\/zkJ1y5dHuXX3GF\nUE5nKgWnpASPuTNShITThJXAlBjSdcKQQ9Z\/mM3XeQdk7bNW4F889hguufRSYX2VhdA0z\/QZlrWR\nyuV8\/QpPX1MLru61NJGvkh3G8kzXzSaTsCg\/VdmYQbenpXs6HbA4W5YVu6sGIL\/XImw\/9lhM\/vOf\nveOZp56K1197TaqHjFTGyQVMP4xMEFYuqcdz0fjb9Om+CBkAAhZmkfFH16jEI9Sm56JFmkuzWV+8\nxEwmg5TGHt1EMZZMx7GAcNCnKNJpXwdJiDQNXZeOwYJlWR5BPlJSkl996oJepHYwUFNfPv3A0R08\nbxFmpqQE2489Vruz62GesShWBV\/+TTf5jlUvjSjShqxdXauKzoBlUmbbnXdiwnXXefnj9u3DLs40\nKW8HxoMjR2Ln6NH4+I47Aj7LPOi8g7x8ugNjN2iZtn8\/OpYswYGbb5ZeQ9YqxNNTdsx2ojQx58Gk\nY\/3Xyy7zHXeVlOB9MoNDgbgvEBJOE1YgGiEyra8jW6SbLrGj4xmTNN51Z2cvZXrpWm1V6SayLMtC\n3aJFQr1lUJFq1Rip8759dPzxmP63v\/nSzzjzTKx\/+WVhHRWhE+lgWRb2V1Whsrc3UEbUb5m0BSBv\nzGltxebGRm1XDVZP1TnQv01cNT6+4w5MPvVUX9opM2cKiTNPrygEdFA5UASw5HT7XXfh2LPO8pXx\nCDOBYVg5tqzI+gwEfZkDbUjaFJNmx\/GRxC+0teEjyG9UmJtoYk1W5cdqZdYB8xXEWqRHdnZ603dk\ncWHS\/SK3mVBCUUCIcTKbRTaZxJGSErRXV8N325ld4kwg+2Ll5YlC8rz+7LP5Ohw9WCtzV2mpbwMS\n0lYhYGJZ1tXDsizU33AD2t1trXWINtt+2DL0oJTMZoGlS4HmZi+dt2DocHk53nGnxYnvMn0deNdI\nRVhl14\/OZ0Pm1fX04GBrKyyBL73jBBcxsvnsb9O+ycQCobJ4fNjYyI0ucuwNNwS2CpYh7PMfllDr\nWE1NLKNsGh3PmMZXvvpV\/NJ13QpDRMPqR5dRXZ99dXWo3LnTO952553aepl8GIU9t40nnIBpf\/1r\nIF+3b+MZQ3Qxee7c\/L01sFbL8gFwLc6AfmxoNi+OsYTI2PLpT\/uszWHlhMHRQpx595iN+MIjzDry\nwvTT7PFJjPuPDEbbaNOgdwhkrcmiF5PnTqELFVk\/k\/lqAYD1L78sjetbCFhUSBSuzbmlRdkhNe7b\nh4x7bdsp6zAX5Foz1lM6L6BjzNM2tDwRYeZZOXgWKMfJ+zHLduwT6RAXRKHhVO2x1zVDWdF0rdAi\n2SZEmrU213d2ot39zXtPDpeX4zdPPQWLkiEiyuS\/jFCJ3lWT+hPa27FDQJhUC6TCEGWZ\/6hIPg+s\nq0F3aanPx5P9ODxm0aJADFoewlhUwyAMUebl6xJsy7Lw61\/9ChdedJEvT7bhCA+60Sh09NSpX9vZ\nqdUGm6ciqzIiqXNvZDjt9NN9YdFkfZuRNbi5GQduvBE11KYfOn0YW1b5vmoSZ9Wzp7oHpgsDw1ib\nZTC2xCtkFcpFQxds+2Sx3+HyclRTpPmc11\/H8889RypJ5emck8jKzMooiHsGAR16LgxMrMZRCLZJ\nm4OOdHqA6Ar08rmja07zFxqql8+yLJx62mncvFfWrxf6JbMkIptMYntdXWjiyuZNmjPHN2OiQpSB\niZBVAl7Qf5HMuIk0\/e6U9vVxyTIwQJhF7Yjcb0z1J\/VE7+O2O+\/ExNmzvfxULofxCxZgB8eKpLIy\nmw46Ksu1Lngbwrz4s58hQenBc\/UxJYgsdCyaUWBKnEXPCXtMb3ktkx+F3JpYdU3KVPb2RiLjsndJ\npIvu\/czYNlK5HDadeCKm\/uUv2vJFZXTeo87KStRSUTuItZnXnqjfkvU9HiTEGYD3gRr1nTAlzt21\ntajs6NAuL8Nw4SxheB7PmkunEcLsOA52jR6NaubjUyZPpI+pnrRrhuM4mHH99Ub15SMFowy7upA0\nLmLyvN90WlhfFTZNZGX+e8ZgW19V8mSEmZVB\/gLxmG0b2+rqAlMzdB36WKSjTM\/u8nKfPPZPBNPy\nPL1VZROJhO9PpqeqPC03Jej8O6ur8dYvfyk9pzDXR6aX7NxI9AHyl3L9Ouk\/2b1QXR\/en245nT8W\n\/z1pEhKJBGzb9v7ItDWtI52v0w5dXlYnznMz+eO9q7L3h\/dcqd4DWbui50z2zEYtw+ohOx\/2Gqne\nJ9O+JpcU28JOPe20UH2fSj80N6Pb9dGX1SPpYa+BZVmwXFez96mQZCSPjQOvC9E908Xv3Z1saZwy\nc6axHmEw1JZkHYyfNcsXTi5j29g+diy3rOx8ZC4Wst\/0MfsxpBs1g8DYvDJ94UKfWZslzqqvMxXB\nNq37SUSYTiEuGbx6uoRZBR5hpttlO1udwZfF\/h\/+kCtXNICYduyqcjIyoJJtMnDuuPtur\/yM994L\nlO2srsa7jz\/O1YM3wKuul0w\/FemR3dvR11\/vk61LgFV60s8M75xN\/7588cW+c+5LJvMLKjn6sXpM\nnT\/fmJQWoqyKBIuunehPJUdGMs87\/3ylDibPoaqM6DqJdE5xdtOUydJB2HddVnbTiSdqtU3L5KXr\nkH1eVCJR38E7NkI6jdJsFltGjcKRkhJf1pR587htyvonEUyIMx2jeTgh1PWNAYSv0WQZyG9Ysnv0\naAD5mc6wcnXKsGVZvhqGU6qfCA3Wb7KriuxLIUzZsFbmuEz9g42hegFEOoQlzHTHBuRjJ\/MIs+4A\nokNCM8xKfVVnqWMNEelrWQMWXtlAbTJQqurwZLCEuWfECKx\/+WW8+\/jj2nroEgqRLJ1Bi\/xtv+su\n33FZX5+QhMkIc1RSaPLH+uMCwAtPPCEkXKxF3VRfU5117ovqLwrZVhHQRCIx4MuoeNZ1nyPT8+HJ\nFLZLRU3iyVO9xybnJKojQ9bdR4H89VZU+PJnMv63bDuyvk\/avmX5+thJc+b45Omen04Zy7Ly40U6\njV01NYGyU+bNC4wxIplhoFtvsKzNwwE832U6tC6xLneOHJlPSKfx8fjxoWRH1Y\/8\/s7llxvLMbY0\nf6GtzRegXgaR1dmEKIeBCTEfbKhWL8cNVSckStcZdESE+bVXXxUOogACnVnGtrHvhz80GkjCdLJZ\nd9pSZ+BVydJBaV+fMfHmDey6BIA+tiwrEHaqP5XCO08\/rSRhuuerQ0R4ZUzIkGVZGL1wobKsTA8V\nyY76x4MpwZ08d65WOdUzMBjnayKT3Cfi629y71XPG9u+zruhenZEdUTPNjCwUZWuzirkKCu2Th22\nbDtDIt95+mntumyerF4grbkZOxsblddZBVFfIUQ6jc2NjdhMb4jhgo0DHwaqcJQ0hsraPJw4DhDc\nKblz5EjPukw+dng606FQdXicThpt3FX6SGtcRz3SzFGCEGLScCaTUa5WFKWZkGiaiPNCZ7304otK\nmWEx1A+mTocTRaZupwaIv6BlnYZlDfickb9sMokdDQ1G+urqSIcxA4A9tbXGpE2lB13PdHDjDQw8\nXcLoyvug2Tp9upZuKquginTT18OEyJA84lpC\/sr6+\/mDtOQ+mtyLKMSRt6Pic88+qySWsutSSAIb\nRb7qGqvuhykJ09XB5M\/k3ER6j+QsXgrbn4jeC5M6YdqdeeqpRvrx0nkfECzYPlglU7cPCfy5fs5b\nRo1CLxPff\/LcuQHyLLt2PD1sQSQkHYSxNg811wiLcddeK7Uuk\/0h6EhPYaHyZ+atm6OPdY2\/LEIt\nGaetzbQSPDeNMP7KqjqifJYwH60PHg3TF9RUhklHK0OmpET5lc376t9eX58PXq\/ZOUYBHQ7Qlx6x\nHV4HrCqvGhh02+XV402\/dtXUGJOYKOVNSKJOW2PmztWyaOqcQ9g\/HRxmFpqK9GXdUGRloxLbMM91\nnNeHV3bH3XeHun+65yz7mFO1oUJlT0\/k95Wnn6iO7Jx123rj9de1dBRBRpB9x+k0ujX9VNnzigzX\ngrm7ttZHnInOxGVD58MkCrZ8+tMFky1DGJfTOCJkAMDYa64JWJe7y8sD1mVe\/b9JjDlseZ0AEzzQ\n3JQYXk84cICtLNWDQP9JNYx0obpRUXybAb6VWVb3aCfQcb\/kdOdnKpv9cs6UlOAt94NFBB5hFvkx\nszrGMXD3MotFaPm6bUepr2tFUp27CjzC3DNiBPaSlcrMLpambcRJnOhrwyNV9HGKmbLmyY9CNnXA\n6sjbVfHNJ5+M\/KyGee7j\/jO5d2GuL0+GznXQvT6619TkfpM\/W7GGR\/buy9rlXdOwz6YORBZQ2XVS\n6Q4EFwQSa7PJPYoCq7kZe+rqsHX0aK6sSXPmcC3gKui6aWy7886AH7kpjha+wlqWgQHrcgdxE5KM\n8bpE39Tllg1WweOcVVSMaBNE+rwjIcNoBTPUHvR0nghxfR29JCFtR+uiv7gRR6fE62gJYRYNMixh\nztg2elMp7FNEsggDuk1aFrvCOox81SAvq8Mehz1XWV3evcmkUtg1ZYpXtu7AgdBkIax+OjJ06uiS\ntTDkKAzZDnP+sr+Js2fH5oYQ9pxMLdi69ybMM3H6GWdolw\/73Mnqi3B4xAhhPR3rtqy9uHWlwbM2\nh71WIpD7fcTdEt5UR55eJmW98uk0rOZmbOW4axCEIc9JSTg\/GrunTvUdD1X4uUJxHBFZJr7LjuP4\nrMtEl0JyLp5s0XbZYV0zAFPSzDGNT1uwIFBMua+3IF2XKPMsPFFkmyAOOWE6kKjtqUieThu8F1+1\n6xHbKWVsGzvq67Hn9tsjdaoy8GR13nKLb0CP0pGzx3HoH3awJ3VFnfJbL73kO7az2VDERkQI4iAn\nugRj\/KxZWnVEusdNHFm89OKLyvOj\/1hretx\/JlDdd5PrE+a+y\/SN81xF56Xz7JO\/XCrla9f0WdQ9\njzDvCK8M\/d6w+NIpp2hfO7ot0XUDAKTT2FtX56sTxrJLtye7b6KyAIDmZuyprVWS57gRxVcXKMz6\npTjAc8PoTySwfexY7B49Ou+7zJBlEURc6tzzzuOWE\/kqi2Iyywy4x4d0zQAibKM9rbMTm9wtnh0n\nuINNNpuFbdu+dF45GmEjS7z4wgta22Wr2v97Q5iBU\/Qgc62YHJcHGiLCDIFvcVSoBl6TdPY6qK4l\nb8AqxAcW7x6d\/KUvceu++cYbSDAykplM3kVDEN6PRZjrIIPK2kDX33nPPYEOOkybIj1MwLZx+hln\nBMrozj7I2qfbOVr6qih60nVffeWVwAJW3vNfCD2iygirl4hoR9FJRMAdx8Gbb7wR6C9IWd4zqfu+\n8+r2lpSgrK\/PSHdZG6Z5HtzxZs\/SpQCA0R0dKGOm5umxauvq1dK2bNsWhtml9cmUlCBJnX+UrbVN\nQHhOXIZCug+mJWZse8CqDCiJskifbXfeieMFhtAwa+LYNHrMcRwH0xcuRFWE59KcNDsOYFmoclm8\n4ziYtmABNq1YIb1RLGGlb6yMuLB5IiuzDiEejHBvcRPzOB\/+sBARZpkf82ASZvZ6T5w923fMumaY\nyFSRYB0LGQ+691RnUOXhzTfe4KYnXd9gSAY707ZMnk+VZVAlS0VMdacA4+4DXlm\/3shawXu+CqFX\noWTqtik6TxP3Jl79qIhCjtlnWOdDx6S9yGXTaYDzsakaS8g9CTPeBMhzOo29LS2YuHu3V2bSnDlC\nQsqTFTtY8nzgAJfUk7FLpqtt24EIYqzeb7344lEbp3nctdcKnwNClgEMuGFQ0Fmgxx4fKi9HRU+P\ncT1R+ShBKVQIZ2l2HJQyhHfq\/Pnevu8EPGszX5wTeOl0rF68+nrq+9tj6xbKIk1\/7RR6IBORLR2S\nRJcJS5h9X9y2jZ319cLoFSroWOVk2Lt8uXGbKrIa9WNGNriayP3iySf7jjMlJXhn\/Xpv5sVxHOy8\n5x6MveYaf9sSMhLVCsuTF\/YjgT0efd112COZ+lSRclPwOu3TTj9d2LYpBoM06yLqLMJQtxmnlX4o\n2o3zWhwpLUXpkSNaMk7+0pfwmzffDJSJTJ7TaXzMEGde\/zbozzwhz+6i6NEdHVLyDAAf33GHUJyJ\n\/oNlbSaxvk1BrMq8e59JJLCLRMMA8mR5EH2Udd18s9ls4IOGYMb112MKGzLS8BxCu2cAwGHbRgUV\nN3nq\/PnYtGKFq0eeGGZdH0qVdcnE2kzjheefF5aNIjduROmABhukYxP6ybq+mzxMmjPHI2SAa2Fu\naNDycZLpIzvmlS8EoWXz47o\/uufHnhNLmAHgt6+84nNV4una0NaGfQb66Ogigw6RFcnbde+9GPO9\n73nHyVzOZ6Us9MIXnXvz2quvGi0Okek47tprsfOee6TtHQ1QXTdTS7PoOCrCyOuurkZVV5eRDN12\n4vro29fQgHE7dnDf\/7d+8xuc9MUvaukChB+7PN9S20bStfxNmjPHI6BDPYNKxiRCnsft2+fpyYKe\nvST6JxKJgL8ti9dfe23Qrc0m11XH\/S1r29jd1JSXy7Esm+rE67P7OQssZX7LvN+5XE5oYabvU2Nv\nr7H+NMKTZsfBp8rK8H5NDbK2jRFuWA9CnMlLw5veDutGwTqIs3V0B3uZlVlHngnhHoqOQeUyEGX6\n+o3XX+f6j\/MWU8RBmFX6sGXonceA\/LSPLgmNw9IjGuTjsK7QA+AXTjopkK\/yMScgiwFZmBJhFeKS\nJ3tmB8tSq+uHrVOHLr\/r3nt9swAyeSYYLjKitjfU58Gtq3hWC6mPtlxD8v3Fk0\/2WZtZuWFmiizL\nAm66CbuXLsUEytrMKzukBNodn3ZokGfAT6BzuVzkRX8iRDX+8HgKS5JF0rO2jSOlpeiorc0npNNw\nBDs86+ihws5Ro1BDfYiGsTITwszbiZr4MgekhLi+kSzNo3p78cz06bCTSRzDrkakkMlkkBKsXCUI\nQ1Kff+45QJMEy9oFCtORDfmXtAA6LyNvVfWbb7wBC8Hzipswm94LWfn2W29V1mPrF2L6UGZBMvUr\n5hFmAPjdq6\/6PmhEcm1mVbGu5Txutw0TmbSs0bNnYy8zUBX6XSPt894L0XmaXk9S3mRB4XCH6NnS\ndWkIm2cKE1mVBw9q1S3kR4eO7KxtezGlx117rW+7b561WfVxGoXE0T6rE2fPDrg7RLFqxwZ3k62d\ngBfPflR7u3QxYyKRwITrrvPprSLRui4aYa4FW0fHkkxwpKQEbQ0NAzyKGrtFRNQ0LczMYNgyrFug\n4zgY192tlKVCJNIMALkpIdxtAAAgAElEQVQlSzD1P\/4DH9bUYMaBAz5rMwFx07BtW2jpVVmlZVZm\nGiYuGiZlTDCUL77JNKBITxFh5rXBLroDwhPmqGSZWJkJVAsAVYNdVGusqh1RfhgLzIa33grIEBET\nx3FQs3AhDhr6esdtXdaR6TgOdt93H5quvlpab6g+eqPstKb7sTIYMNFhMK2\/w8EdgwW9uUlc7hQi\nRJGdSSaVG7GwbamIcSji3NyM9qVLUdrX51lwecSZyKcxGGMp9xq7Y9dewCPQ9QcPchersWDHoS2f\n\/jQm\/\/nPUdUUYvysWd5vk+uVtW302zba6uv9Gel03iIbAy8aLC6UoQJT8HQgVmbfhiYhdYtMmq+6\n6iqsTSSQWLYMH9XVYXp7O4DgwkDypSLbVceEvD7\/3HPcemEJMM\/iHEXWcBgIVeB93fMIs2jan0eY\ne0tKsOe224zaN4VuPdkCwLCuGLJ6vBc26nQtm\/cvX\/hCoMzbGzYoQy7SxNOyLJT29RVkgCqU2wYt\nN0m5lxSyU2bPhedDbmoVDuMadTT0JSqEPaeTvvhFvPWb3xjLjxOsbN67E6f8WGSn0zjy\/e\/7FgOq\n5H7hpJOw4a23lO9WWIvzrsZGrpuGDGFn53TkafdVLoHeD2A\/h0AnEglhCDoRWGLNbdcQOnVYt4tc\nLhc0bkksw1F0MrEy0z7IMh9mwB+PmedjTmQ4jjNAmiOcV2TSTJRCOg2ntRU9ySRGuA8Q7d\/Mltft\nGERlZTJyzGIhk7q6U\/MyvYYKUUmoSPe3X37ZdyyyLu9sbMxPcYXSQg7VuelamcOSZR3wrE4yYmra\nFo8wv\/P224HrrfMMsi4aJvpEfcYL5bYRFabnJfIBlYGn79FMkgdD17+HNoZCfnd1Naol09Eb3npL\n6OpFy5QZA7TfmeZmYOlSHCkpQanr7jBx9mzPlSHKDJWIxMc1I+Lrs93IG+3uH5YuRd3Bg0j19nL7\nVILeigqUHTrkHU\/+85+x5dOfjqwfgej6ZWwbWdtGNpn0+ScD8blciNJ48nVxwYUX4ulf\/1pZjv5Y\n4ZFy2sr8hba20PrQiI0053I5YMkSbF+2DOO7uzEik\/FcNTavXOk9fLIwdKy1lxDT884\/X0sHkZU4\niosGCd1SiKnp4QaVWwagJsxxwmT6mr33e5kpp0KSZZGMI6Wl3DKFsFabls9qbgcbVn7cxJo9brr6\nauy+775IbajajKu86bXQObejiVizKLRLA6+9ONFTURHwa46znTCzXIIKvkPWr9lUn7Dk2SvT3Iy9\nzKLACdddh2133sklvoPtMhRKdnNznjzDJXBuDGgAqOruRjKbRWlfH3ZPnartomHaX2RsG5lEAplk\nEh01NcEC7rhMn0cUQqsDlVWZd3yorAwVVGQLlSWaEGaedZkux1qro1iZgZhI81VXXYU1a9bkDxwH\nO0aOxJSDB5F0b8yUefNgWZZHnrPZrC+QuukD\/9yzzyrLFNJPmUfGeQ\/B0TSw8XaVowmzlCwDsRHm\nMIugWCtzNpn0LAImZDmOKT+fHowrkgn5Z8t+\/p\/\/OVD2nbff1lUxIJMmLoX42AtDKGV19vz4xxj9\nv\/6Xr2yUBXOBjlQBnRBdIqiuxZ4f\/1jpsz2coGMtV+WLyr+9YUNgRoVXdygMFESPQzU1GEnFeo2b\nLMd570XxmkUgLho8yIitzj2xLAu46Sb0LVjgWZuBAYvzYLhchYHRGEHtReCLBtzSEiDNZDY0w4wT\nOmdPk2PahUQHhSDMPHcIE2y7806cqGEcFbXLc+EohJUZiIk0A1Qw7SVLkFi2DFtqapBIJDBt\/36v\nzJR587xddlQuErrWLJXVTmRt5tXVdQXh+T+bduQmpFq7QwoJ0TbMRCbP\/yqqdbmQU9K7Ro3Skqmr\ng8y3TwdRy\/EI82\/feUcrUkaUdmWuJXFhsFxCeO1Geebe3rBBGpt5MFxY4qgzXCDTPQxJj6pHoYjb\noEZGSaeBefN8SexYInLRUPUJUVw29tbXY8KuXcJ80344TuiMGSI9ZNtrI51G929\/i8qODi\/p2Hff\njWejE83roiKzUVwzTMqL3ChU8mgyLFv4R9KnLVgQu5UZgFFMfim++93vDhyk056yG91pcqI4CU+W\nEfj\/sF8OpkSUPS7kizYY8gkGe0D8zZtvYsJ11wUIc8a2cbCyErs0CDMhJolEIvBH8qKSF55+VnOz\nchA2nfpj\/+hzIODF29W1LpsQ5kN1dVo6yuTS\/ne69WRtxHU\/RTBpeziQR1N94\/gbbpDp2nT11YOu\nu8k1VOXz3Jtk\/R35G2zsJzOBFNg+mIVunyXLk8pIp7FtzBhfkmphnJbcCDCRLe1XJYEO\/vDkk6F0\nkyEKP4pbhzCcLUx51i2DJ2Pq\/Pmh9VEh1rc4l8t5f86SJXCWLEGfbWNTQwMyVIcxee5cAGLiTOOC\nCy+U5utcEJOLp\/PFw6bzLM+FQCHk86zMhDCzyNg2djU2ovOWWwCXmIoIpaxTLiR4fsQEcejDkxGW\n5IQdSP+q4Z6kpV9ra8EHIROSF2d5GXEx\/eMtwOR9+MVJeOOUXejrI\/qTnZ\/sHGXlolynOECuXb+7\nadJQ93esbqo\/Om6vSFfe8y5rL1R+Oh1YrK1DnGm5qnutc\/+j3LM47\/VQPjdxQJc3RV0smHHXyolk\nsoZMx3Fw0r595MCoLRFiJc1XXXWV79hxHKRuvBEA8HFdHXqoDU4mz52LyXPnIuvuJMgDL\/2Zp5+W\n6jBUX16m0xhhEefLxSPM2z7zGW7ndaSkJG9dpny2Cq2fCjw9OwSbmUTVK0zneuD227VkiTp+kVuG\nqc5RCIeu7DiIm6kO9Yxlf7BA7kHcRHYw\/4YrVM+p7jMT9Rqo6rHrFeKE6j3R+Uih\/3oqKqRtvb1h\nQ2R9dc+Hxt76+tDEOYxOhXgPeDJk1mYWp8ycCcsK56M\/FFxHNZtfyJl31sgqaotYmX26xahX7PNF\nPmszUXzJEgDAzqoq9KRSPssvbzc51YVXfb3w8uJ4wFTpg7X4bzAHvoxtY1tTUz7m8TAizDzwwszF\nca10BwUdObq6\/NPnPx9I+91vfyvt+FUDwp4f\/9h3XCHZxZPAZIAuFIj8tv\/8z0EnhLwPl8HAqP\/5\nP4ek3TgxXMm8ioya6kEvUA2jR0GvSTqNAxx3LlaPqNCV4SuXTheUOA8WTO5TLD7Mhgg7wx5lZp6X\nJzvmBRqQkXGac9G\/p1A+\/B\/U1OStzMPZPQPIW5vZE3GcgdWdu6qrsZnxsxo\/a5ZvVxsVTEk1nW5C\nuMMgDKEPiyidqsjKTJCxbRwqL9eyLhNdBguWZXF9mduYXSjjIMs6hDkOOWFBD\/6mg24Js\/FB1AF7\nsMmRKC5qGLJmoudgk7xCIM5rpHPt9v7f\/ztsziesLA+StRwyMh51ZiUKaB9sdu0FD7ouGjRMry8A\njzizESSONuIM+McCE2tzIa3MUYmvrBzrWmFqmDQpzy78k5F8x3FwyLYxg1p0GScKtjLBcRyftdnb\necZdJMgSZ8dxMH7WLM\/y7DgOLrzoIql82bFunmkdnfTBHkxJe7rtygizt9Bv1Ci033rrsCHMqkFl\nT1OTlx+Hv6lKho5FKuwgKLIy614LkR6i89DxP40bcRGcwQZ9H4D4yKeuFT2uv6MJw+F8AmRY8h5F\nhQnh0kI6jT5qrUehr5+uXK9cc7MX8YjG0UacC+maEAZxEmbTeiq\/YxOwEUl4shzH8dwy+hMJbK+s\nLIiVGSgQab7yyit9PiX0FwmxOudyOWxubEQ\/sxAqm81yXTYAvz\/z0WRtHkyoOipRR+RZlkeNyi\/0\n0wwlV+gBi+18LStvZaY75r7S0vxOhDEMACoZdD6tw9hrrvEd95eVxTbQE6IW5vxkbcZhqS00hpIQ\n8j5eijDDcCb0w1GnqBDpf7C+ntt3EfDWSpgaH2T6KPVubsb2sWNDnvXRhQzjjnLKzJlG9QtJhkX1\nZYvtTNozdZfNZrMef5S1OXX+fABAfyKBTSNH5q3MBeJhscVpZmFZlndxyW\/f9tbpNJBIYFtLCxKJ\nBJo6OlDW3w\/LsqTEmYaJDzFdlldPNy0MBsvXmYA+TwJClif+6U+B8u+ddBLaa2qMYy4X6pzojl2F\nrG1j38qVkbfu1urYDc63TxLFQybvc\/\/0T4E0NsKGqsPR1VO27asuTJ8Bk8487D0p1HP5+3ff5VoZ\nCvWRXMg+YzgQwTh1GA7nEydYQ4EIYZ+9Md\/7Hnbde683Nqv00GlHZWxQztKm0zi0aBEqDh\/28siO\ngcMdvHPjxW22LAsbXnqJu\/tu2HbCotCLD6PK5cW8DizwAzBl3jwvbXN1NZxsdiBiRgFQMPeMK664\nImBt5n4puO4au2trsWXUKPS6ETZEF8zkWIYou+KYum6EkRVFJgGJsywjzL85\/\/y8G8YwIMyWxY9\/\nTIP1fZeFmDNpV5Vver7dgigeMvAI8+\/ffVeoD\/s3VLFgTcDTN0pM28Z\/\/\/cCa6xGGGvqUP8dTdDx\nBz6aEOe90q6n8MPmtUMvgo3jGqus0ZZl4cBtt6GvtNSn09HmpiHCYD2ng7mAz+Q4DG+S8TSy8I\/U\n7ywpgeM4OObgwYJZmYECkmYg\/5DQZJklz97\/JUsGFgrW1GArx78JyK+wZFdZRvFl1iHdcX1ZDYbL\nBvELN1pYGWJHv7hefpZAqeSy55S1bXTcdlvk9lVlosooJHiD5HAhTFH1GEoy+I+f+1xssj7JKNQ9\nHOoPg0O1tdp6DJf3b\/eECdLyrL++SF5cOonQtmKFtzCQlB3OxFk2ttvUecig46IRl1tGofyYw8gR\nyXzyiScCdVgrM3HJAIA+y8LuESPg5HI4KcYts3koKGm+4oorYFlW4IQDPs7kP1koCAiJM8Anzzrg\nkeSwxHkwrc06UBFlrpX5zTcjt2sKEcnTqcdid1NTJB3iKEOXJX+5VMposLQsS9vKbKKfqm7UP1VU\ngEKg7T\/\/U3lucWzMwYNpFISoZCouuTr3rFB\/g00Uda6fSVnZX47ad+BoDBE45nvfC1Uvrnsquye7\nV6\/2haKzLAsTZ88e0ucpLHj6sn7NKgwWYR5MK7OJBZotS7tk9FkWtlRX549DGAFNUTCfZgLLylub\nycNO+ziTh4m+OJZlwVmyBF+95BKuPLoeIc6WZXl+T6z\/sI4\/8WD5HMfdjo41OWPbODxiRCD9zTfe\nCOUHHJbghi1L8umdrADkz6kAVnLd85OVE\/kzi4jRZ\/\/xHwPpIsI8FAOGaZum5XV8KuNsLwz++Ic\/\nFLx9Vk7jv\/879t1\/fyyyhxqiZ59FFAOC7n0QlRuM2cAhRXMzsrNmxbKWATDzdw4jq62hAQAwfudO\nL41YnLffdVeshqsoCPP+v\/Xii9oLAIeKMJvK14GJHBGppmMxd5aWYk95eZ4wL1mCK6+4IhY9ZSi4\nA+Tll1+ORCLh3+zE8Yej08UByc5GrP+uCDpfQkNhbdYB7XohI8wZ28ahESOwfexY7F69Gp96441A\nGV0LjE69MHKILFU7QJAwh3HL0NFNJ5\/nRtJ09dV+\/ZLqb1GVPiLr4GCR5jD3M2w7prFsC43PfPaz\nBW+Dh78XgixCf1mZNJ88CywGK76xkbx0OraFtIP9R0NlbdbZ3CfOd9Knp2sU4UXVGD9rlvA+DVY\/\nodtGlBCChXS3UMmIamXWkU3+f2rzZmEd8juXy3kuGY7jYH9ZGZKZDHIuYR6sj6WCW5qBPHFeu3Yt\ncrkcbNvmWlxZazOLp558EmhpwcHKSliWhfrOTlT29HDbY4nz9rvukuonsn4PplWP1x5NjFW6ZGwb\nR0pLccD1tSMdzhdPPjlQlrhlsG0O5vnqWp54MHXLIHJVJFVHhg66f\/QjbVk8K\/Mffv97aZtxWnKj\nyB0uModigPx7tUoW8lrmSkpgURvqhLWk6+gYp\/VTV16c144YmuJG2113BT7yE4mEd37v\/u53AVcx\nOl8Ecu5x6mxZFtDcDMdxsL2lxWdxBvLj4\/a77hJavAvdL0T1Dc6kUkj298cu31RWoSzMunWz2Sy6\nS0tRSfUNPGMmvT32H5uaUNbfj0RpKZzFiwHkQx0PBgaFNAMDIWfoi0GHoFN1UI7jwEqnQWJq7P\/B\nD9BeXQ0AGNXejnLq4WPJIPkqJdh2553SKTqTPFF503RWR516hCh31NTkE1yiPJjkNwxMiDrPyqzr\nlqETgUHnWsVpxTIpHxdk1ztqtI3BIjBDiT\/98Y+BtEK9Y0PxQTBY6G5sRFlX16C0JevDw9TljU9H\n673pKy317QbadPXV2H3ffVpuUqrrRwh2nO88Ic\/bly4VEmcTHYcCvPBzmZISH2k+ZeZM4222o1qi\nRXmq3f7CWJl5RJhcE5ow0+V9Psxu+sb6elQcOZLnkEuWAI5TkA9MEQaNNF9++eV48MEHkc1mkUwm\npb7NOp1R9j\/+A7Ztw2ptxd66OliWherublR3dyvrks0xWLAWaV2SbGKVlpFjHTlkVfHu0aP\/f\/be\nPEyOq7z3\/\/Z0j0aLJVvSaLFk2VjKTW6AsBN2yAYJWdjCZgMaSbZlyZskIMmNp5XnPtdDuLlgW9jy\nbmyNjbFZbIghARJC2M39YbMYmxvAGGwsW8tII412qbvr90f36Xnrrfec856q6tlU3+eZZ7rPec97\nTlVXV33q7bfOaRY4ANIVZR4vhcCjBMw7tm7NzX8e0WUetbG1l3xJaQA\/\/tGPEjlTE+0iEAoLnYqM\nF5pkqlaBNWvGpCvNrzRpjzPjY\/fZZ2MB+Vl54fnnex9UtWksj\/m9114rnrfM9dglDZiac3DeIFPa\nvBnbBwaweMcOlAmAUnDWjjGrskaZgWakOYv\/TgDzWOYu15TpTfShv8fmzUOj0UCtVELX5Zcjah1j\nYxVlBsYQmoFRcDYRZvOfwrI20htFEer1Osr9\/c2yUgn7AewfGAAA9I6MoOf4cVSE+Z65LyMb0Gqi\nPyE\/pWshu1Yuo14uo1aptKPJJcWy1hNRoZFWDsyAPCdzmshcp6LLUhpIiB8poqnxMRY\/HY936o6r\nPs8H5p73\/Ofn4selsf7FYbxuQtKeSzV+8lBmgK5WgZzmCR\/rqPWRWbMw49Ch9nsTbQ4NOLj2W0dS\nTKpV7BgYQO\/QEHpIdNKkMnJ4nsg34D+8\/37xYcDxBua0UWVXH9R3vV6P1UkL2RlIpsD8y\/nzgVa7\n8uWXt4+tsYwyA2MMzcBofjM\/YVFgDjnQ6\/V6fC7EVuR1T6mEUgugjU49dAizjhyxgrRWWaPNNiXy\nkoFEJFnbz3hGmbPkK9t0eObM2MN\/aX\/GzvsizW133Hyzyk+eD5v5bthczwu4Ln6T9efnNLJt608e\nfrjzT0s7xpFXalDemsgwkkZ5RKDzlvSTfl7af\/XVmOH4lYzqxS95CR568EGxzne97kS6BqpVDAng\nDMSjzp36HNP6LZfL3ujqeAFziG9NG1uZdDyv2Lkz9v6+e++NLVoCAI\/39iJqNJoTSPT3x\/oYyygz\nMA7QDMQjyjTa7LqA29I5SqVSO+UjYc+isiOlEkauuMIMAgBw6sGDMZDOkpKhLTMpFo1KJRZFBgBU\nq5kvctL+swFzKOxL9nlflHmU+VhPjxWYxwOWs6Z12NIy8rpwZ4nm5RHV7rSGbrsNvZ6f+U8m4B8P\nhZ4zJpNCvocnpk9H99GjnR5SR2SLNv\/goYeCFvfxgXNH0jU84Lz9hhsm3XGXl9JAse3GJi+IBkbz\nl30+6ZRyJsLcaAEzqtVYDvPKlSuDx5dV4wLNPE3DfGAh6RlctVoNlUolVk8fNGy3l0AaAFhUmvo5\nPn06yo0Gyo0GTtu\/v10+\/fhxAEC5Xm8+oAag3t2NermMkdmzRV8AvA\/s+UDWV\/+qV7\/aWueSr0+N\nXVZJecxDW7aIfY8FCLvaS1PNpd03oaCbR2TYXMw07UKeNxgP5TGu33ve83IYSb6av3o19tx++3gP\nI5Ncn402R3a8JAVBeH3adKw0\/eepkd5e9Bw\/3p46z\/cZaD6jMY06V6sYAoCBASzdvj1WtWTdOgDI\nHZ7HG8R9\/Xc6wpwmyh1FkTXCHkWR9SFAYDTCDKC58F2UXBlwrDUu0AyMgjPdATzHmYqnbvBoM9AE\n526WXK8GUP5AHWkzDaMnxxFiMgL5pJY40Vrsskrr05WWoYWmsbhwiQ\/+kenltGOl9llsQrd56IYb\nvDZSlPlhYbVGnzQXag1Yu96nuVHK40SW5nPrxPH5yE9+0rEFgELaZp3hxKbxuOjYPreQ7+F4gosv\nCr3gvPNSPwyYpr9Mqlaxe2AAi598st2XiTbbxuIbgw+eO\/JZVqvYbok6L12\/HtsV5+WxOqZ8KTev\nfd3r8M1vfEOs6xQw234BSAPIki8KzNr86OGZM7GXLFpi1vWgbfrGYCETSWOZrpcQB+Y87h5OOOY9\nDB3beJRRMKSRQP5nk5TLnMbPeKsNzK2bmZCFPSbSjYDpx7U8c1bfrjrN522rdx03Wdr4xjmWChlX\nmv0Rqr3btmVqH6Lx2D6u+atX5zLuLG3T\/nV1dWHkhhsSY8hzH9FzRqc+E7oYk89XyDnYVUevcbmo\nWsVQby+2L12aqFq6fr34YLltTBq7NPudBvzMn3aKufGOMIfaAs10DBePRVGEZ112WaL8l\/Pnt4G5\n0ZqDmbaJomhc0jKMxhWa+\/r6YncQgDu3ht5p8DZU9E7OZ2srS2OTVlm\/hC498N3v5uKn0+InNQPM\n5uKkUeiJz1Wnqad\/J2bM8F7UpJkZQqLM\/MKcBhak7fC18V2oQ2FrLFZ4Cx3Tc5773Ez9nUxKC5kA\ncGLGjI705zuW8jimQsapXd0yy7609R2kahW72Yp70iqBNMdZ24f2\/JJbMKFaBapVPLVkiTjTkg+c\n6Zi0x07I55X2GBwPYE6bhmHEZ8jg9VEU4axLL8Viku6aUCtgRhmx0WiMKzAD4wzNQBycOUBTve2v\n\/9oJv\/R9o9FI\/ASSR0J7SLJ8ljJNnSQpyjwRgNgnfjIbmT0bpc2bg6FQY8PtQi6qtJ7nMw+bebM9\n\/VFpgJmPLRQ0pZO25kIWsj+1f6Fg4\/Jj850WULh++uijuUJOyPa5PsOJKu3nf\/DGG72fXR7jyGN7\ntPItD059hhyDaX2F\/CoHQJzr36xKyvuUXmvG6hP9zmZWxqhz3uLXYDPblzaFJcR3aF3aIKLUxrST\nHvjjPs00czyf+bPPf34sJYOme0RR1LFUtRCNW04zlclvNgdTo9HApz\/1KbzzXe9K2NIcZVe+chSN\nTm9iZtbw2WsPVsk2Sxl\/YDFkXK768V7IhMo2Tn4COzxzJg62VnrUSgt4IfYh7UulUuIBU26jfcjM\nNbaQ7cz7ohbqL8tNquazkj6DNH3Z1ElI9fm2bdtEB2ebEnmPlQq6lAsbALq8Xts+yxI00O7vkaVL\n0fv44+33ec4bnlau65wkaSYNrV\/NPtZ8Hnl8Zu22rRuB7QMDmDs8jJmHD8fszHVHk++cZUxp22n2\nxVikZIT6M8xly5M+69JL3b7MdHIMlk1QdbyjzMAEiDQb0WizTb5UC1uaB09Ez5LHMxEjt1EUiVFm\nWq\/xMdaSHvzbN2+eeplsbWQiS0RH8rXoggti7+tsukNNHz95+GF1tCl03DZbOk2bZn9obXiEl7fV\nRtekqKPWT+gf7ePZz3mOc9uz\/I2lOrWv8tjX0n7R7jPpc9Pu5zH5LJTnK59s+4PPChXqz9cH0Jy3\nOa3\/0OdNtH5z+cyqVQzPnStGnQFd5LkTwBxyTZb2RR7AnCXKzCPVtVrNOqWceS8tYuJaPptHmScC\nMAMTJNIMNCeoNoue+OZzpJFZV5QWGI1w0kVQbFFPbbkUEbO115SVSumn2rOJR5k1PtL0k1YSMO88\n\/XTVBShkjHmcfF0Xc6AZpeFl1P65v\/d7mfrOy5bXSz8rh1zU0ozByHyHtD+3SSdz\/h1yKfQY4FNV\nppXtfBLSJnTsYw3rGpkxRVGExrRpqAREmn3+QtpI5\/E8VJsxIzZfszmn56k026xpZ+qfWrECZ\/zy\nl6nHZrZZe3yHRKi19qJI1FmaYQOwR57HIsJc6+5GhT0wZzvf+fZvJ4DZV+56hoxHlqMoQq1cxm\/m\nzcNfsPTEz3z6021YplDeaDTwvve9z7pdY60JA81AM7\/5jjvuQKVSET8oA8gcMrWvs4CzZAfowFmr\ntOCcdl7mtMoK19Kdfd7ALMFrGvmAGQAOffSjQX1qpjLT3OC4xqfR\/tbKWVpQdtl2Cuxs3zMOzHnm\nuv3i5z+PfT5pwNclG+zbtjXNtmU5h6WVFoJKrE\/f9vkiySH9S23zgNsTDJp716xRp2iM1bh90cru\n\/\/E\/cPySSzBNgMqQPugNgy8dI\/Smx+XT64vM67x4xw6UhanfKDznncZAValU2r+AH5k1C7P37fP6\nGA9g9o2DPvDHYZmX1cplHKlUMDRnDqJGA9OE\/c99TTRgBiZQeoaReYjPd+DQD873gdN67ao0Lh+h\nyuOuLkSu1f986nSahhRhfvqMM7zAHAKHnQRmmpoh2XH7NFHmsfgJU9Pe9lNuiI+0KRa8D1fahmu8\nIX3RMfv+yuVy4k\/TTtoO7pPXz+3rS+XXt9\/yToHR+ou6u2Pv561a5fw8fJ8XtwsV9609TqgOkxVL\n0\/bvkgn2hLbT9Et9DG\/dmkg3y+JbY5fGdyZVq9ixdSu2L10qzrIRRRGWrFsX\/MBg2mvnbkvqSIj\/\nsQJmai\/NN33mJZck0jBq5TL2zZqF38yb1wTmKBKv9zwtI4omxoN\/XBMq0gzE0zS43vHOd+Izn\/50\n7A6V3n26XlN7+mFLH0onos3aMl9\/3H6so8xpZMacNiUjZB9R2ywRcddJn5bvuvVWsdymRx95xBll\ntvngJ7ZOXWwkMA71wb9T2rHSbQyNPnJ41mrFb\/2W17dWUju6TVq\/0rbw\/ZE2ypgZOARJx6ZrfIev\nuw49bGEC17jMtmu3mZ77Q+Vq69t3je7u9up6aeQbNz+3aduF9A0AQ0uXYtETTyRsXviiF4mzavj8\nhqRrhHzGmQM8JAdi92wAACAASURBVPI8e2QEcw4cSPik1yzXQ4N5BpukBU7GC5h5PQdm8\/7MSy5p\nvie2J7q6sH3+\/NGyqDkrRhRFeMO553rHOhGjzMAEhGagmaYxODiIuz7xCbznve9N1NOVA\/kqgq4T\nG4co88GH5FVqwXc80jQA4Dvf\/rYTyjTjyssGGP08lqxbF1sZUQPM0k2QzzYvaYDZVx4aZfZF0TR2\nrvYSaNr2bWh\/msiS75hOe3Nk8x36GQLAE7\/+NXhML+9fX3xAduCuuzCHnfdCc7\/TQF9aSdBmgxrb\nZ6059s1\/3zMvrnFJ70PaunRixgyUDxzI5EPbTgLoPOAZAEqbN+PQBz+IHS99KRZ\/\/\/uZfJlxafd5\n2nSNTNtcreIAgJErrmjDsyQbQKft27c6IPWf5pfpTkSY+XLYBpapv1q5jKfmzWuWmTo2KwZ\/APBT\n99zT5rmJDMzABIVmYDS\/mcucdOkDgFI02Rd5NqrX62g0Gu1p6Xg\/GoVEpvOAblOXNsqcBei1ov6X\nrFsXq\/MBcxZ4yioXvPFpmEJ\/xnz0kUdi\/UivjTTRJo1c\/YTCS4jvkPLQSLQ07nmrVmF4cFBsF\/oT\nn2afpL1Q+m7qbXaabfCdM3w2WcWhJyRqq71h1Pxka\/tVJo\/Is8vHwQULMJ0Al8lrThsV5X13dXWJ\nNwzcLg94PnTaaZlym7lCwNko9JeFkDZcJmXgAIADJPJskwHop1rPhQT3RfTU9ddj+etep7LNo04r\nDt0G8NtRZVZfK5exff58U9AE5mq1bWeOXWkVQHNjMNGBGZjA0AzIEYXlGzfi8S1bxC+hFly5rTkg\npLwxqX0W8OVlrmif5iKoHWOoskSb0wJzFiDMQy5glsr33Hijtc4VZU4Dm1m2VeqvVEo+PCcdqyG+\nXWW8PhSUJb+29659SuvOPOss0cbm39W3b6y+tlx89g5ttF9SXqCcNlpoyug40kKzRjZAo+daLVTY\nAjGSDapVgEzryPuO2QZI21bap6mjsNUqhgcGcGZ4y7ay3rxoPyfb9y70M25LCc9RFCVSDn3zPof8\n6pFXXZooM61fdvHFiefM6OtauYyn5s8HyI1l1Lq+c2BuNBr4b0ND1j4nOjADExyaV61ahTu6urCS\n5L+95Jln8DiSJzOukGgzEAd03wwbknxT36VVyBi+8+1vq9tlgWKbDbeVgHmXAMzjDcsan\/wBwOOt\n6dq0Y6FRZm2foXauthQY+X9bzmhI9E+jkDxl6ebWZsu3w2bnKgOA3zz5pJjalBbo0kYYuV\/pBifN\nz9hcml8ztJFjqT1vSwGuk9Asiffr2hYbhNmiztSG5zXzWTR8N1sume9w6GefGp6rVeCzn40VLV67\nFjtuvjnMjzAmoHNpMiFtnX4NPAMAm67O1s4F0SHbYANUn5+8gHnZxRe330sTM9RajLS9t7dZF0WA\nWeCr9Z5\/T8z\/2ewXjHvuvru9+l8nru15a0JDM9BcLRDsoRFpnmYOxYD7ZCtBrinzRZ1DQFYbmfZF\nlXndq1\/zGlX\/oWMLVQgw7zz9dJQmITBL2rdokbWdJsqshYY8tlfq01xMJaj2+Qr9hcd18Uqz3bax\nhkSwJaWd+ixNRFq7z7Rj4xcmjbJ83lmizlLf81atwj4hHQ9AIg2Py3Zc0UCI77NzAT3vy1nf3Q0Q\naHYdk9r+qKQUDe1nkSnyTJQHOJsx5R11Dmkb5I88NBhFEWaPjGDW4cPitHVUS9evj\/WjXYHQpqyf\nndSeAjK14fnWtXIZx6ZNw+7Zs+MOyDVdOr5MWRRFeKXwS4wB5omy4p9PEx6aJf1FXx\/+ZXCwPb2R\ngV0+j7ORLcIsgbOxMQdMuVzuSLSZ\/kzoioBze5tolFnbJmScXDa\/HJaBeEqGKzLtU5pt8e0DLThQ\n1SuV0btqhUyU2QV7acfmk\/Gx4LzzEj5tkWdf32nHleVGk7\/ff+edOI2dYNMeV9rxpfEfsh9tEU7A\nPsuPr580MG0bpxQ5DmlL27g+P58vl+iY6APiPltfFFcCXG4fRRH2X399bOVN3ibkM7PZ2K5vLj\/c\ndiKBs3Y80ueTFrrTbr95oM2kbwBwAjTvh0ei+YN1zr4VEWLfew7INh+Gf2rlMg5On479p5wyWh9F\nbVC29Wn+0+njoihCL1vO\/JN33YUomjhLZGs0OaA5igByYph9\/DiA+GIn0iwaaaCRnxzNwaN9UDA0\niqxpn8aPtk2IT58faV5LWw5zJyLGIQrZZp6asccxr6YtyhwaBU0TNfX9rEz\/77n9dmudrV3IGNK0\nCelX2j8h75cIn2GWBwbT3mTY6nhOs5RCkxa6qE1oZFrjW5K5eLr2mW3\/28olCPKNSQOkxi5kW+l5\n1JWioYkqd8ImzQ3PWCrkJiztjWDWSHuiXeuaRlM4AKB3aAjTyEI3Ltlm0ODX0lBgDq03NvV6HbVy\nGU8vXpxoa6aLs4kCsvR++caNiQVNTJ+TBZiByQLNgswDgRySqWhZmmgzVciDgrQ\/n60E9z5wfs1r\nX2v15eonrTTt+ZRyQAuYr7suZqeJqnPlDdhZ+s0SZdb2kQaYJV+hUWXpvwZgeXRPIx\/gS+J2\/Pto\nWwBCox3PPBM8Bl6WFpx99qVSCaecey4O33NPu8wVVUoL05pIXNqbISnqm+V7yM+dNujikKWF6tDI\nM7Xdd8st6F2zJuHL5ce2nZJNuVx2pmhoANQG1D6d\/uCDeOYlLwGQX7Q5VFmhP017lX0LondHETAw\ngLnDwwCAcr2OSq2WiERrx5AHENtkcpNrtRqeWbCg6c9UkpkvpD6k84UtwhxFEZ5FVj0EmlHmeq02\nqYAZmMTQ\/PyhITxmScewyXZS0oCzuSMC0j0oGBrxDfH97W99y9umk1BNUzKMLxcwa\/vtRDQ69EK9\n8PzzY79ynGg9ACjJFWXWlvuAWXuxC4FjXsbHILXjF2ntTaK0HdJ71zaZ1+Y7a8rN9zLNMUWBO+vY\nQuUCcVtZHt+NtBE7rcycq6YPX5TP9z0JjfxyW8mPz68tsukD3HqlEos22763mpvRTpwHqWz7RaO8\nwTkEaEPhV9rv2ghscB\/VKoZpRSsKTe3mDg+jXK+jfOhQ6r41YzvROk8emzYNALD31FNj9bVarR0I\ncoGw7aaaf7clYF6+cSPms9SMyfLgH9fkgeYonqLRU69jxaZN+OXVVwNwzwAg3YXzD4uDs+0nrlKp\npHpQkLd12YbArBRlzuJPU2crd+Uvl0g0NuRmQdOm03L1PbJlS0f7DQE+3z4y9ebGkpbZwNkWXeZl\nHFhtygrKXLQN\/b6aCJyrHzOWeWYuUaJKpSJudxqFQLbtonf8s5\/F9He+MzHGtPJFirL4sck8Z8LB\n2bxunHIKKocPt8tOW7kSI5\/4RMKP7zth\/NJzvbaNz1Yrfh7bd9ZZ6H388fb7Beedh90f\/7i3P9v3\npVM3NlTSMfnjH\/0Iz3\/BC2J2\/IZAAueskWCXjzT7yPfLiaYvl7x2Qg6wgera\/\/yf+K3\/9\/9i5sd6\nepq2gdtUrtdxbNo07D3tNNnGvN+8WZwVw+bbZce\/19L\/5+7cmWg7mfKYqSYPNAMJcP7d4WE8Fo2u\nVS5FnXmuM2AHZynaa+y5NA8KaqPH9IQfGo01UWZtm9A62\/g1D\/ylXWkxzdg10kKm0cLzz4+9P+6I\nMkt69JFH1OMNHZvWnwS3LoDWRqOpb26XNyhz2fqn2xrSz4GREXSnvHHLc3uMzP7j3x8fNOd2gc+g\niJyP6XlNAuejt97aXvnQts2APm3B\/NfcINBjxGdv8+2MZm\/ejBJJ0XBtB\/WljYDaFjrJQz4QlZbZ\nzhpxlvoJjSRrP3tbW26b9\/fJaletAl\/9aqxo99VXu28Crrgi6QO68dfrdUAAZl9EWSqTvts84nz2\nhg3oYakpdwwOTkpgBiYbNDPNOXGiHW22gXOpJD8kCOgg2demXq+LF7O0gJcGnLV+QutCIswH5szB\ngTlz2l\/etOPVRC7T+NYCvMv3vq1brXVSakZewJy2rQ2YT8yYkQmY+efkaucaY5rPko+TtrelWPhu\nyMz3N49Ic1rQls45dHuiKEKlUkkNvHlFmjX+KdDRCym9oJo6\/uue9AseteHTyPEIs21MvsgzB1Cb\nPbX1fdbHZs9Gj7Cstm18oe\/5uLL4C1K1ip0DA7mBs2scrhuVPOyl9tqbkbygulKp4MjMmZjB0hec\nEhYHUwOzUO8CZk002gbMURThJeR5EaPJCszAZIRmFm1eceAASu9\/Px676qoEOAOjkWZpbuemO110\nmdrxNrVaDaVS8sEkm3\/pZOsDiCiK8Fphqc08o8pGXlimNw3C7Bi2\/eRSCKiEwlaaMfAoc+iS2T99\n9NHgPoH89hkF5vmrV8eP1xkzYu2liLENnCW4trVLc5y7xPvjNwUumJdg34imZkh9+caSZvwuH+1z\nEL0JaEGzZKeRNoqUVjziROHFBc62WUKoyuVy7Lxs2wbjWwuE0jg0gGCbyo5D6aFFizD94MF2GV\/o\nJKs6GW02sh7nFnDu1Bj4caNRmuN7zKLLGeTzKdXTGTq0EOyy4d9lGzC\/qjXVKXPiHP9E1+SDZqYF\nR49iwdGjeAyjHxyFYhpplqaoA\/zgTE\/ENiCMIvuDglpQCLXn7fKos\/VvfdjPAsya\/m1tNNLuo7yg\n3SyZLcm1mEmWPtNKgkn6\/8hVVyWAWRM5loA5FKqzKAHBBrDItkigTLezu\/UwDBWPNI+32uOgN+EB\nv5ZI6kSkWYoc2y6qttxmzJ6NLvIglAuaxfZIXsh5mbS9tvMHh31a7rNLnPuqVTQuuABdAXPxTioJ\n4Lx47Vo8c9NNahedgMo0ftPcgOZpx6PMGrDVlPPp7GzngRCQtkWV6WvDYUvJTeNUUf7rPo+FhA\/4\nPSQ3znxgtrsf6cP2XVSkE6nNXpp3URvhCfnyfuub38zNJ4\/CmTZL1q0T0zEOz5wpzr8c2r\/rJ8ss\nfiXfWjtNLrPLtzbK3An5gFkCSQ0U+x4mdLUzbc1r6c\/4sNWXy+XY\/1KpBHR1Nf9ar01dpVJBuVyO\n\/Zm2CUW6tKBxUbnc\/OvqigN0CvFou+\/z0PzRfSt9TrTefCa8rsR8njZ3bmLs1C9\/LfVpG5vUhh9\/\n2j+zT+m+lXSUrZ7Wu2ZNrsdalhupXFStJs6Pi9euVTUNBVtt4ElraxuHK8ik\/QUjTztq7yunDJIW\nmF0sZANmfsPaaDTwF2wl51aluA2TSZMTmgFx56\/YtCn2oUrg7LpL0kKyps4ctFpYtvkJURpwdrU5\n\/cILE2X1chlPn3EGhq+8sr06kpHrRNWpbbfZamHcd3KtVyrBucwadQLSQny64Jq\/lh6wk\/6H+qSv\nbQDmgh+wv3K5LAIzBbZJJQPN5m8CisI3v7HhnxsH566uLhy\/7bbRGwPL5yOBru2YMJ93SBubHb1B\nkyLN9L9NR666yrrfJuSNGpPmXDx87bVtcDb2PnBOe47P6xoT2ma87Hz2NmDWtPcBs\/SrjQuYKXet\n2LSpvQgdcejcxsmiSXYVcevlu3fHwBlAApz5B2xsjHwHja3OJtvdXijgSvnM2rahbWh0mdZJ6Rgh\nd\/baO3rJNg+\/GjseZXbNy5xW4w3M2rQWX1RNA8eudraoIQdlCmalUqldbyLMJtrMI400Ot7qWL2P\nJoQ4NL\/nPeM9Iq94FJuCMv9825+jiaQroJl+vjY4doG7DaL5jZwUWc5L81evju2vrJoIN4PDixbh\nWE9PrEwbcXZJug6k\/QWR+x2vqLFkV+vuDrKXbKTosqu9hkF8wMwDkeb97+zd6x3zZNX4f9uySPjQ\nn71vXxucXU9wSweBBo41kWNeXqvVxER830HrqqepGb7+feWmzpaKUevqwtNnnNFcrESRjqFRGsjW\n2Pr8uux4f\/VKBQc+9jH1GAB\/asZYA7N0gdb8941TAmDaVgPcPFWAQwwHMApKlUolEWm2RQUnrShQ\nTuBos0+2tA3zWcY+R6ajR45YoVuCcFdU2XVsuqT9Lthklqyfyor6+zG8aFGiXALnPKKxWX5JHM+o\nsWTLl8wO9cX5QjM2aUVJG5e4gJnWG4ZasWkT5kzRKDMw2aEZSHwYc06cwPKRkRg4uyLNUp15PdqF\nG5xtP33w95onWLXytQ8B56Xr1zeXwebQWC63c5d5KkboeELt0thnhaWF558f+zz3nHGGs39takbI\nBTpUoT73btum9un7n9aHr46Csi062YYtGm0O1UQ\/kQ8OTooUDa2kzzZ28yNsnwS\/Ut4yjxSb\/uj\/\nPMbuqg\/RZIg2h4AogOaDgWedlSim4Jz1uifJ59OMN2s0OIudz7Zy4kQq\/zXHQ6YhwOx6HQLMURTh\n+UNDzjFPdk1+aAYSF7+Fx46173gkcG42yQbO8e71P+Hwn1A00WZbakbaExBtx+9yTZ2B5X1XXSVO\nnG5ET6AhJ6W0483DTrLlaRm1cjm23Rrfjz7yiLr\/sVTIRTnk4itFmbU+bG1c0edEJJmD81TUFIJm\nqz71KeuNDwVlG7jaju+8U5Z8bVw+Jlu0WQuiCdsWOPMpOhevXZsbYKaxC+k3ivwzM4UCeMg4\/\/Nr\nX2u3s6lWq1mB2dWfDZglPqL2hqN4Geer165dm1jIZMIHJwI1da407IN50fAwoqi55rn5YDXwTMvM\na2rL67kfXpYcZrOsXq877xJdPrSytTWRZelnoXq5jO1Ll8Zg2eZTmztMRe\/681QavzbbeqXSjjLb\n7sJDHwAcjyhzKDRQe22UWRN9s6VyuHxweBb78fy0zxy66yeqTgZoBpqfjweIXWkVrvK84Dn0+8bf\n12bOjL3vXbMmqL3vvTg7TAplPodWqxhaujQ2q0YURaoc504EXow\/37Ew1tHlNO0MLIf8kmzKXcBM\ny2xRZfpaCjqu2LQJZ5DpI1uGtk2ctJo60AzEPqCeeh3P2b8fALB840as2LQpAc4cgl3gzA+wUEi2\nyfUFsOmb3\/iG2j+PKlNQpnVmVgy6DLbGZ4iNNg8tbZ8aW+mkKT78JzzsaF5L\/k2UuROR9k4q7U\/Y\nPiDWRP9cP6fz3FPHQNIB8WT5nE4WaHZIykMOPW7zgucsN78jS5YE9zfWCgVHV6rG8KJFOD59eszn\n4rVrrfCcd+Q2bztjq1UngNlV7yq3BflsQSFbVJm3pXnML9u1i3ds28RJrakFzUDsg5pz4gRe0cqv\nMdOgpAVn857\/5wejtEKTD67N3aMtmd+\/ye6Dk8NyrO+uLozMnj06K4YFFkP7NDa+k2seJ6w8H\/ao\nVyoYmT8\/2J8GrDUKgQBfHc2bBICGZVVDbQQta24zBRdbCocabt773lFYTgvOk0EnOTTbfgGR7DS+\ntLYdUbWKY2zeZv4dzaIo0i+Ao\/mlVNvWatffj70LF+LIKack6jg45953DnZZUg\/zHCf9VTorMNtg\nWQPM\/M8JzFNYUw+agSY4k4OAg\/PyjRsT4Oz7G3WdDpyTQ5RPWrZpY0L9AaOwbPtCHevpwY7FizHy\nT\/9knRXDB85po85pbELsJFtblJna7Vm6FNi82envec9\/vrXeduduu9vPUz4Y2HfrrQnbLAChjTLb\nooTcB4fqiRJ9G1dN5RsCqk9+0lolRZrpf5sdLZdea5S3\/cGFC3PrayyinmnV7q9axcjVVzsfEMxy\n7pd+vfT5C03lC913ednztR7yAGZuz1+HAnMURTIwT9EoMzBVodnIAs5R1Mx1PnvDhkRk2fyXItCj\nbsPBOTQya74wf\/CHf6jfXoyCsu0BPzMjxvalSzG0ZUsuU8iNJzhrHtiwiaZlRFHUfHjFAswufz95\n+GE1LPvAWbMP0sBkI8VS0dr8Tlt02BZdttlq+iVG8n+X7WTWVNiGjMrrJkqd+tOBvrNEm7Xnx66u\nrjEDaqmt6K9axY4zz0zYLbrgAlUfeV8\/8vQX6pfbL9i+PVZOA2d5ArM2qKOdqjeKIrx9iq7655L8\ne+1UUhS1LzivGBrCA729aDQa7Qv42Rs2oFQq4Vcf+xhKpVK7zhxApVJJhLQoitp11Ib\/pBPy3pRx\nP1Tf+PrXwWtigGxpd6ynB0O9vSg5oqiuFAoNnOZlA+hgWHshiyLdz5ZDS5Yk9i3X81\/wAtWYzHaY\nfqU61\/usF+mQn6tD2nLY4CBsS7\/QQHUamEmlyXRSL5VGx1sqAZddBlxzzfiOqVMSfsa3nX+peL35\nvtPABfdDy6Q6m0JsbTq4cCF6DhzomH+fOunf6btaxY6BASx+8smY3eK1a7Hj5pvD\/Y2RneYzCd2n\n9Nj0TTcXAsy2aLIvcBMCzCbw+Pa+vik\/U4akqR1pNopG0zV4xLlZHeHsDRtw9oYN7TpTro042+rT\nfNlc7Uy5L6IMhEeVXWOVLjgh7alNJ+7yQ\/3xh\/9MlDm03588\/HCin5Coc4htiOatWhV7z5\/czypX\n+gSHattP65potVOaKPNU0MmSojFrlrXKlU6kqdMoz0i2U9UqTsyYESuS5m0OjVpS5TVvszSGF7zw\nhWpbqlKpBFSreGbZMnFKujR5znlHl0N8prUPSd\/sJDBTAKbj0gDz6y688KQEZuBkgWajFjwbcD6G\n5IFi4PlZl10WO1CoDYfpUfd+cHYd7LxMKj\/9wgu9P2kdnTYN25cuxY7FizF85ZWqh\/t8X1JfnW\/c\naX3lYcMvYhIw77nxxiCfIePS3OlrbF0RAiop1eHQtdd6x5wHNGjTLGzR5SKPmeljHzs5HngEgC1b\nxGLbDZftlwkDjBQcQ46vsTgGR66\/PlHGo5suac5R9FeuNLK1+9EPf5iwC7o2VKvYvWRJApyB0fmc\n8wZmrToNzLGgVr2O0y+8EDPYNG15ATMFYl7HGSYUmBNTy51EmvrpGZKiCK8olfBAby9+Nnculh84\ngJ521ejPdSbybE5gT1x7bftA4z\/tSdGBkJ\/fedmyiy92boJ5mrZUKrXn5zQpGKhWnSddqX+t+LZk\n6SOLDU9zyTKmPUuXOtsZSakZvm3gx0aaFA2tLT0J+i7AwTnE8EeDbZFjFyCnGUfLOP5\/cNBtN9lF\n0zROQvEUOH7Mu1ItQu3HSvVyGV1krv75q1dbF0HpFPiFgFkedu39Xa1idytVg9u50jU6NT6XbdZ9\nRO2jKHI+6P9vX\/lKcODKBsy2NhyY+WsXMP\/W+98vA\/NJdG46OaEZaIIzACxYgF\/MnYtyVxd+e\/9+\nEYbN\/7MuvVSMWDy5dWswOJ9x0UWZf048Nm0ajk+fjgNz5gDVamxy+xCY42WdBt40NkA6KObvF5x3\nXgykDp16qvjwn2ZcD\/\/4x856yZfvBsplq\/WbOBF2d6PRaDhv9HzbmsfP3Dao7sQSwFZNxpO7Aeap\ncgOg1TnnNP\/uvrtdZI5dk7Ms3Tia1\/SYp9JCdBawltrw98O33GJ9CFDzE77NL1VXV5d6BVpNfRpb\n2\/5HtYodAE7dtAkzDh2K2ZlUDQ7Ptj75\/g4BzzQ3TWmAWVrMbB5bcjoNMPNyGzBzuA4F5hWbNuFl\nu3dLA7OOeSrq5IXmll6xezf+6\/bbgXIZP\/\/Hf0RXuYz\/1lpN0AXQFDTOvOQSEaZdZTZRv\/\/9F79I\n1D9FJ8hvpV0Y6DAnRwPPGhjSjGMsbICwfWPz6+rPpGWY\/hrd3Th05ZWZxm6zk25IaLkPpLPYmgsx\nPSEagDB29D09nukxG3r8SMe7zU5r63EU\/z+VZbbxJLtAUfFfU2x1EjCnjUTzviiQU7mieRoZW1e0\n2dbXRLXV+tt31VXYJ0SdgfhDgmkhPS\/bNPa+VX9nHj6cql\/bsWm7cfCBMn8vAfML9+yRBqYa\/1TS\nSQ\/NALC6BRl3AEC5jF90daH0oQ+1YXTekSOYffQouskBYovWaSMXtA2XE1aEh\/nobCBAEp5tkvoJ\njUB2Coo7bVOvVLBHMVuG8eWaNUPbJ7fLG5ZtdcO33IISRk+KpVKpPUMMBWfqR4JpOlNG2hsy381F\nrpoqMG0izeb1ySRhezVRRe25mLaXAIL2Idlz0TINXA\/ddltyEaIU05W6bPlMImn8Su1c7YMBtzWz\nxin79+OU1kq+RibP2ZeyoenXd9xktTfisCy1PeOiizBDAc2aGzLp+OTtXYAslZl1LaIowrP37UMP\nP4ZOQmAGCmiOaeXKlRgcHES5XEa5vx91NE84e0slDH\/oQwCaJ8KFBw9i9rFjsbYuiLaVHZs2DUAz\nF3nETLdELhI80vzVf\/93wAIrHJyBUXiuWFaCo2MKVShca+06Ber04b96pdJexEQD9NIJT0rNSLsf\nXO9dcGyz9fkxJ0QNKNO+TBsJuHl0jx\/7ucPxyRRlBk7OSDO9WWgXxY8zfqzZgML810Kxz84FU773\nvGzPihWY99hj7fe9a9Zg98c\/HuTD956naXRSwcBsVK3iIICDAwNY8PTTKNdqMRtXrnNIOkvIGEPt\n6WIkrrbScarp13bsScBsq\/PNDsaB+YV79sSB+WQ6BwkqoJmpr68Pg62HiswdeldXF9Df3zwpA9hV\nKmF3qYTShz4UA4suBgiHZsxAT72OrkYDlShCrbsb3bVaDCTMvMkiVPzpn8beSjBCJYEzMHrX64Jn\nqR\/+WtuGywWIob6oDfctqdFoJKYyOjprViKPWevPpyzgTPt3wbLLdv7q1YhYnQue+TFlizpTULaN\ni0fyqA2fySDtzVomTdaTPQXmUgl4\/\/uBq64a3zGNlUol4NxzEysGSnDApxG1gS0HhDTwbBsDr1fB\ndX8\/Dr\/\/\/Zixd2+7rnfNGgzddlswkGeF6ywKgWWnbeshwVnDwzhlZCRWJeU6dwqAJRCVxBci0fqd\nz\/KZv\/LlLzvH6QJmzY0ikFwim9pIwPxynsM8Wc+hOaqAZkFWcAb7abC\/H2iBdFdXFxqterSAwcw6\namC70qqLSBk8IMyVFpyBJjybNlkfGpTK8wBsagNkT+lYdMEFMYisVyo4dNppQf3a5iVNOyaXXSgs\nS+BNX0fd3VZbKULN4VkCZSkf2tRzGOdRaA7YBqhTAfTJGG0+2S5aURTbZholoxd+GzCnheIQu\/hw\n070\/PHcuspsPGQAAIABJREFUekZG0EWiqzZoSwvK5nvoaxtS3zG7\/v5m1PmKK7D4N79J1Bt4fuam\nm9Q+0zxc6fKtecDSdazMOHLE2z99rwFmzTFMv0O0LoqaKyWb79YrGNSfdOcei06ueZoD1NfXh3q9\n3j4ZNxqN9h+9I6P1QPwANLKdfKUyzQnA94V2nRxMG7pUp+Qr7UlQcwLP4j+rjUnL0Njb\/P74Rz\/y\n9qk9QWtPtpoTo\/R++JZb1Lb0uHId667vA\/\/P7RqNRux7xX2r1Wg0\/6Ko+Z9rKoH0lVfGbxCm0ra5\nZAFmX0R5rOGZn\/PpcS3Vi\/3092PvmWfGfMxfvdrah2usrjZ07mbf9017Xu2o3ebN2LFsGY739Ii2\n\/FdEl1+tpP1G5bt2SuXSddL2EKBkqz1WjaTvCD8maV2j0cDyjRvRaDTwsl27CmB2qIBmh\/r6+lCr\n1doXeXqhtx2Q9L0LSLgPfpD75LPVgDMgr3Pva6Md21jaSTZ8EZhjPT2IPKsihvTtuxBk3T7XSVFz\nAW200nFcflx++bHqunE0ZdJ3xbw3+X4UnKU\/1X5rNIB6vfmnuUGZCif9kwmYqaIIeNe7AMB6jk0D\nu3nZ0TIN5NpsGpdfjuM9PbE2FJy1\/dBxybvTD8tpz7kaOw1kxrR5M\/Zeey2OtFaM5OM7\/cILcfqF\nFzr7DxmrZGuukxyWfdti+2xs6zBIttK13rVwiWahElq\/fOPGNjAn0jGahuJYT1YV0OzRqlWr2l8W\nCRqA5MHJI23SQe86qXJbWi+9t31xteAMJO+eXf35fGVtm9aO7j9p1cR9W7cm7Hx64YteFNRvSJ1W\ntmOE1\/EL7PHp0622rmNPsnWBsuu965ca6TulBmcTaTbgPNUVRfG\/qSbpZoBtq+\/ib17HXXQenkOg\n1nfe379kSSoffJttiqLIOS96nudjyc52rdD423\/11XjmpptwcM4csd7AMwXokHOvNA7puujzG3IN\nN\/rKl7\/sPY6MpHxk85pHkm2BPnOePXvDhraNmL88Fc81GVVAs0IGnG0RNWD04OWJ9q6D33YCDYHd\nPMEZaOY9u+aWDD0JadqGnIA1tnyZbKC1iElKf1Q\/\/MEPnNuRFp594\/BBrfTeLJ2dBZZt8OwDZQmc\n+feGv6eRaH5jmpAvPWOqid4knAzbCyRuFHxQ2ykoluxsP3\/TOs33LtGmvx9Dy5fH6nvXrIm1c+8y\n3TlGAuc8z8OSTQhE2nwCwMGPfhQ7li2zwjPQBGiTuqHpg4\/XBct5ADN\/CFA6B0t8wIGZj4sfU+Y\/\n92miy+Z98cCfXgU0K7V69erEBZ\/\/zwLOPLoWCs6uL3MoOANop6VoT3R5ALFWLlsTYaY2h0491buI\nSah8J85OgDXv1wW8jUpFbevz64ts+EA5JIWDl1n3CQVmfnxPxRQGs53S9k5BNep1RNOnx7a58u53\nt89J0jlvrOFZaiN9V2wQZH3f348T06fH9kfvmjW5AbMRBec058CQvvIC5rY2b8aBj3wEzyxb1lwR\n12J\/+oUXYsm6dV7f5rxkg2XfeG3HpNR22cUXi\/Mzhx5bUt8AEoxC25+9YUMMlhPAHEUFMHtUzJ4R\nILMIyuDgILq6umIza0TR6CwA5gClTyvTBzD49F3mtTnobTMJ8Dbc1tXejNPnl5ebE0ipVAqaccM1\nbs32hfg04ikZURRh17Oe1Z7Wz+cPiO87X2qG5vOy1aetk+qjaDQaZeqOtS4kkm1sBhhWJ9kC8Rkz\neFtz8uXT0\/HvhG02DWMHNCM85jX9ntDZa1qDGz25+46ZqXARMDcJJ4kajQaiW25B97vfPbrdUTK4\n4AJQqZ62SwvPUj98PNr3Up9AM02j9\/HHne00dXnUa5UJgtPakrmdpYVRjAw4P33jjbFy8wtXlrHa\njgWpvfmsZ5KZM778pS9Zjz8zRpcvWs4Ddea1AWXz\/niphFfv3MkH6tzOQk0VkeYU6uvra3\/ZbA8x\nSXd\/5r3twJbacblO6tJ7qjQRZzoufieuuSBo6tLYAf4ZKnaedRai\/v7gE7TN\/oc\/+EFwG1992jpT\nL9k2KhUcvvJKES6orebCLx1f0n\/z2vbAHz32pT\/bTDVSWXMjT7L0DJO7PcVyuOn5kKr9WbM\/6Zjh\n\/12\/fPBfL0Lh2QbO0nlde14Wy6vVdrTZ1NM0DWdbZb3mvGiD\/Cz95AHMifJqFQf+z\/+xRp6Nlqxb\n1\/4zv6am6Z\/W2z5b2\/G0jE2h5zrmtOkY1JYe42dv2ICzN2yI2RwD8OodO+gACmAOUAHNKdXX1ydC\ngjbPmQM2tXd9CaXXUl2nwNnIwLNmuVCXn5BxSDLbw6PMB089tb3kuA8+s46BthlreLZdwGm9zY+v\nLoutK4\/ZBjMSOHP79vfJlZ4xFWVymQ00K6famqjixwVXOwJIgDlqNDDrnHOcYOyCaZ4\/b4NpH0j7\nwJpvp+uc4Dof77\/++kTbPPKb+Xb4ftHy9aEF5tDzcCrbahUHHWkb5ppVq9WwZN06LF2\/HkvXrxf9\naYHZNR5us+zii2NRZmpD7aQAnHnNb\/x4UGL5xo1iGsbxUgk\/mzMHrzER5gKWU6lIz8ggswiKOXhp\nugb9mdn8HG3qeUqFLV2Di5\/kXO9dJ8S0qRq2RVUMOPMUDpd\/Wz++cUhaeP75sZ\/o65UKDn30o6JP\nM06fXvTiF6ceGz35aRaF0Y6RpjRQzW+lDZm2e888EyV2nNHx0D64T+mYCllcRVowBRhNu+B9SasJ\n0j5oSkepVEK9Xm+ma9ATPt3OqZjPDAA33QSYB1wn4YWOAwH9L4GHCUQcvOsuzHz3u2N2vJ1UboNd\nXs7H5\/ovtdUCY9r6oeXLY2kagLzMttZ36Lh\/5\/WvD+5Dqg8B4FB70bZaxYEowgEAs\/\/2b1E+fBjT\njh61+qDg\/NT113v79AWfpDFFUZR4ANCU23xLNx0STD\/rssvE\/g0s\/2rOHESNBlY+9tikPH9MJBXQ\nnFEGnGnusrmwm\/dGFJgNLFOgdkGHkflC2OCDvpds6VjyBGdTb1YddAG0Fog1dvQJ6VKphHqlgqEb\nbnD6CgFyox889BBCcSwtHLvqfUDeqFSAajX22UvikMp9amFZcyNHX9PjUVoV0ERLKDSb\/+av5x3v\ngBl5qdRcJc\/8zJo44qbSBcL8lDyJtolf6CVglo5DGmnjkCxBswuKbZDu+y\/1wcul9xrgUwNntYoT\nF12EbgJ8aWHctq+B+LMJGo0nMGt8R+ScsO\/DH27aDQwAAObv3o2eY8esfnnkeTu5nrj2kQuWjU49\ncCBW9y9f\/GL7NQdx6dijx\/TZGzYk7Kj9ia4u7J82DXumT28C8y9+IY67UJgKaM5BFJwbjUYbFs2X\ngEOrgQQKrhScTRsuWqeBFZutUVpwNvIBH80X4wDtg0bfOAAkVoOqlcvNFf8UvrT928asBW9bdFjy\n6RszLwu9wLna+LaHH0ehsCzZUhvpAUAO2KaOfq\/osWabRiv0BmnCiuZfTnBwtoGs9NPyrFNOSbSn\n5w4Ou7POOQcH7rpLBcUumNaCrw+YbWU+G997o\/3XX49TW+BsbHrXrMHQbbepxxECxC499OCDHQPm\nPOCaP28Ts2kFE4aANkD3Dg2h59gxZ98GoqkNj0ZL+5e\/X3bxxeg+cULswxddPuvSSxP13O5EqYQj\n3d3YMXMmluzfj6dmz0ajXsfKn\/3Mum2FwlVAc07q6+sD0JxZw1zAaToGnwFASteg0WrpS3zmJZfg\nya1bRWjSRJ25rekzFJxNHffF683NASADtBZoJDsOzPVKBUNLlwL9\/UERYcm3KzXDtDHSjt9nr71Z\nomWlUqm5oAmxPcIARILXTihthJqW0+nEOCyb74\/JReXHtLlh5Sc0ng7lWthhwmuCPwDIITaK5Ifj\nODRLoiA88olPYNY558T6oNNhSlDsg+Q8gDkNKKet33fddYkHAQ04+3y4Ugl4P\/x71XPwYKrxamxD\n\/HI7am9blMsJsa3nXXZHUQKgNeM746KLrHVRFOE3112XKJu\/Z4\/o17Q\/69JLnceqVGZAeeesWc1c\n\/a4udNVqePLDHwYArFy5UtyeQulVQHPO6uvrwx133NGOqJTL5RgsSODMocqUf+H++\/FXb3pTu+65\nv\/oVnhAgmLYF7JE9U8ZBsVPgbPPNT3IakKHj4MAMALuXLGkDs2\/MtpSH0Ihkmnaamw1bvaa\/I1dd\nFYtC2qLieQC0JtqtPVbpuOhNJ7+YSz8jn7j3XqBet0Ys6XfPHHv0mJs0kegJCM02WLWBrO0haao9\nQ0OI2IN5UoqGDWh537TO9VqqC\/WhBWmXna2O5jcbm\/mrVzsjzmn6oaocP+61Ses7xJbvY9dcyqEA\nbgB6CEDjH\/8R8\/fsQbleR6VWQ1fAQl\/0vVkmm5Yt2Ls3Zv\/TFStw5iWXjI6b+bEd27WuLkQAnpw3\nLz5jRn8\/SlGEequsAObOqIDmDsgcrDTqDCTTNQwgA8mLOI+QAcDx1oIVBh44SND2gBx15qJRblca\ngU1mPC7wdUG5mYWjVCqhUnEfjlEUxZZINToya1b7xEdtQ8DZVf6Dhx5yjsnIte9sn0UWeJamoLLZ\nuj6jkAscPdY0UScpNcn4oVFkCkPm+JeOc\/qdMW0pGFMdOXwYJSGVgz534PoVZsLBtJkxZBxF95WU\nl0wB1xVxdj0EyGeyAID6zJnoOnSobTP7Pe\/B\/jvvTPiQYN02fi0wu+xs28Dl+86ofPT3Y\/fAQOLB\nQMlH2n5CbwCktp0AZttCW9xOs90uP12XX45h6u+KK9p1c\/fta4N0xRLd1vRhGxsfY60VcDva3Y3d\ns2fjjKEhPDl\/\/ugx3migcfnlbXv6vTG\/fBfKXwU0d1A019n8vOxL15BAw2harZaAZOmiTwGNw5fP\nVoIrF4AaucDY1LugPIpGHyIEkjnQQDPCHCEOMzvOPDMGzHx70kaPQ9vYIrqSndRfFng29Q3PTQe\/\nEfNFs23HmM2fTRRWXeW2fjho85xm2zjaM21YItYU2l3bzH2PG0zX63FoftvbgPvuy8W15qLP8y75\ne17Go8FSG9tYeLtDN9+M2e95T6IdB440wJwFrF3KCttifbWKwx\/4AGYOD7dteLTZ9R0K6SvNL2h5\nAjNN1\/LJN5uFtk9qE0VR7Nqy14yllc5hbObt24eeVkTetu9XsLmZH12+HLVWfjOHY9PG+KqVSuiq\n1\/FEa1XbWHQ5imKvC2DuvApo7rBornMUjaZr8AcBgeTDgDZRSKOQ6zrxcWBzwYEEwD64s7UL8UHH\nz3OgaUpGFEVodHc3UzJYhFnyGRJVfvFLXuL055NmP9na+YDb5TeKIuy9+WYg4EaBQ7etjpb5wNcl\nCru0X9s0jOY1P4Z5TrPtwkqnf5Qi1nwcPniW6mh5xxUwe0YaYLOVcejgYOp6D8Qv7rTMJgmsJSib\n8973Yv+dd4qgnBWKpe222dlsfPYuO5cOffSjqLAZNWz5zVn60wJwnsDsfJDPIg0wZ9mWRFnrgUKj\nvbSuFZmOSNmZO3ZgFpub+WfLlqFy6NCob2LfaDTa17VGo4EuxL9X9I9+t4p0jLFRAc1jJArPfElg\nesH2Re\/ow4Cmre0BQk3U2QYotsiwD+7ymC2Cjh8AFpx3HgxCl8tl1CsV7D79dJQswCzdIISAM9VD\nDz6oerAwjz41wG1sFpx3XqycRpn5BUI7Llebdj\/kAsVv+KRy6k+6EPHl5Wk9vTnkxyzdV\/V6Hb0L\nFojbZIs28\/+2Mhcwu8Baep1V0ec+B5BnHFobaQUCLRjbyqVIMn3tg2VzUZf8a2CG+z42Zw6mtZZJ\nluDWB7JaeA4B5qxQJ\/nX2OxfsgSnPv10ApzN\/M1pfPK6\/\/6GN6h8hMCy1K\/0IF+e+zV0X6jAWWgH\nANi8OTGuZ7\/xjbH3\/\/LFL6JC0k1saU70vZSyVESXx0eT+FHyyam+vr72qkTmomL+bHeQVCt27hS\/\nXID\/IkfrqGhfvJ10YvKdhGzteL3vpB1FUeKhv+OlEnYsXIj63\/+96oKrHbNL2rZSnyHg4mvnstl7\n881eW99FxAdBvFw6bmk5t5f+XD58bV37au+ePTHfdAl4U05XiqvVarEy89q3SqH0Hba9tu1T1+fl\n2x+u\/Z\/Wh9l2+tq2H2kZ3Q+8zPjm5QsXLbJuP297ZOvWxPHrOl5d5zxbHT8v8de+407aBt9n7KsX\nbapV7F+yJFG84LzzMp9fTJ3vIUDNsSy1ocdQGmB27VfuJ2Rf2Pa561xIRc97pv5F557r7NeXakG\/\nn7SclhXAPLYqIs3joFWrVgFoRp3L5XIs0sWjd\/fdey\/e9td\/3S6b1rrg2FYRpJFe8wXjP00beyB9\n1Jm3l5QlXcM88GdOS6VSqR1hxubNAOIRCukhQroN0ntbWehYNW3TtvP1GUUR6q0HRDXjoxcI2y8C\n9GLgiqJyX0D81w4pHcMl6VcW41s6dqXxUl+mb\/qaf0eM6MwaPPJsiz5niUSHwEbMlgOdYl\/Yym37\nkUMCv5hTex5J5p+9VOcap82v0fGeHlTIT92nrVyJvdu2ObdNC88cxDTwrPHrKgupT6haxdENGzC9\ntWCGab\/gvPOsKwZqYNmmB7\/\/\/SB7qppjFgrjS+Ovk9Fl13nE1s7W1rRbODwcK\/+XL34xAf1SgMG8\nt0WYgSIdY7xUQPM4qq+vD9taJ\/zu7m7xJ27pS\/usyy7Dr6+5RnzAyYjDMrexwTOHbtqOQjXvxyZt\nugYdgzRDRq1cxpBjeVPbUt6+7aVlL3npS63+qa0PYl0gym9yNOK2fNaMY+zhEdf+lsZkpB231MYF\nynT8ruNAe2xRkJbGRMdB+5TSJqRjncO0rTwrMIfCc2tj49vsAVEbDLhsXbAsgbUNpDXj4Nr+1FNo\nsLxW6uPAjTfiNAILodtney9Bvs9O04\/28w0+Dlo6sGULpgvRZQ7OaYC9zCLN9Hj1wSsQn0vb13de\nwBwKyza\/ITdGNvh+SevBVd6XuVb5wJnfPJq\/ApbHVwU0j7NM1Hnbtm2JOZ1NLuZnPv1pvOOd7wQw\nOoMGIC+GIsGztMIaBxL6ngMyrUsTddbUmzEtWbcuUX+8pwd7r70WUIBmFMXn8LQtpKKB1ocefDDT\n9vjqQsFZ6rNeqeBw66lqast9a8djs\/fdDJg29EIiwaoL6ulxJ90Aclg2WrR4ccIXvxBKkMvHZsZF\no+a26DP1Zfv+pQFm70WfX+AFcB01tacGSH1xIKY+XCBtykNg2bad\/EEwyY\/tv8u3rT8J+m3tXGBt\n8+dTWlim277r1lsTzzgATXDedeutqfuX0jNKpZJ1jmTbIiMuaeDbt09tx4HNzuU3D1g2\/xfu2xdr\n94X77xe\/V7ytlLJhrmuGFwqNnwponiBatWoVbr\/9dpRKpXbU2Rade+FTT+FXBJg5PHMos6VsGKWN\nOvPx+aDLBUw0HYPW1ysV7LnmmjYw+4CVbjeQPJFXhAfmtODq6keqs\/m2AZZG81evBoitiTL7xuf7\nbHg5v1BoxuoDaMk\/n3bR9osJB2bXBfLp7dvbcEmPZS4JmI349JA2WxtYS\/59wCwpsS\/4dvzlX6Lx\n+c+Ltj5\/RrZUCn5BN+XSsxNpANZWZ4MRoxPTp6N8+HD7\/WkrV2J4cNDbH5f2eQ0tWIcCcBpgto1j\n98c\/jnkXXoiyJw0ij\/7pNUcCaK1fDTD7no3R9BcCxtobKOnGjdb\/wdvfLo7jBFlGW\/oFhz8PAjT3\ncZG3PHFUQPME0urVqwEAt99+OyqVSnOmCMvCDa9YtQoPbNsWu7DznFAbgEgX8DRRZw4ymuizVM6j\ny8bm6CmnYN9VV1nH5QNnqX86FzSARHQ\/VBqQ7GTUmUeZNf3bAFpzEyC109jzcduOWSCZ20x9zX7P\nexB5+uYXWhvM2rbJl99M3\/NfXmwRbN9raVul8gQ0Q\/czuC\/qzF\/7IskUEjS+feOQ6m1ws\/\/66zGX\nQUQeY9AAs802BEDTwCptZ2u\/96abEuC88PzzE9HmLP1HUWT9NUDre6yiyyGw7PPpupHj23PmJZdg\nFpnVBADu\/+d\/dt6Q0uiysWk0GkUqxgRUMXvGBNTq1atRq9Vw\/Pjx9sXr7k9+MmYz\/\/DhxFP65kvI\nf\/qhr3m99KABbwvIM2zwdraTklRmxiClY9TLZTyzbBmGBSB0jVGS70JonuDW5DOH9qOt00ZMeC6z\nmRQ\/69hCxmBs6HGjEe\/DNcMDnbGB\/knHnQ2KeBvXzA70OyT1Te35a25Tq9Xa\/\/lraifN5GHsaRvq\np16v48S99yb2F+9H+uP70rUPjL15L42V7gPbZyjtd25jO06kz9x1zJy2cqVYzt9L45VsaZntu8KP\n65DvQIh8xzvVnhtvxFG2nPzC888P7t+0oTLHmRG9WdT61kaXbb40+0JzHbJdG13t+DFBr2PU9nee\nekrcJvo9lI5r+p05ceJEAcwTVEWkeYKKRp3L5XJidohp9TrO3rABj2\/ZEovMRVGUOWVDG3U2ZUa2\nNA+pbOn69c1yZnd45sx2dLnE+pfGJL3nksajaWce2PAt7+3rRzvGNOkatF9XO41fejHQLFbCx+zz\nz8dK39P+XIv18PLeBx5I1NNfZ6R0IFfKiu0YLpVGczmlaLH03aHbxKPqvs+BfhZ8u7sYePiis65+\npNfcj3QTLrVx9S+VL1+xQrTT5Ebv3bYNc\/v6rOORXqfZL652IQCcFpa17Wn9yJYtwMaNmH7wYLvM\n5Dz7cpyNeNrF94TvWYg0x6XPxvU5agFae1y4boxcPs+85BJMYykyn\/\/c52LATb9X\/H2RtzzxVUDz\nBJeB58HBQXzizjvx3ve9r1333J07EW3YgF997GNtgDEXZyCel2mkSdmgtsaGvqf+qR\/qS2pnypau\nXx\/Ly42iCPVyGbvYCn+28Ui+fVDqGo\/U7nsPPAC07KWUDl8\/rp\/eNWCr2Z5hYW5mTR8aIOdpBzZJ\nNzBGIQBtjil6\/FLZUiq4Hv\/lLwFyIdKmSVB7Cra2\/qR9I0Ey78vWlkrqk+4Tvn9c03mlBWgO7j6Q\ndNloIecXP\/85ooB5e\/l+MLnNoZBsG5MG4EJ9hrbRtJdsRnp7AQA9renojKR0DSkv+dSdO1X9asbX\nydzl8YJl6Vg569JL8bwnnoiVf+6++xA1RmfMoDeF9Ga0yFuePCqgeZKor68Pt912W6ysp3Wy45Fm\nCZ453EjwzGfZoLbUt5ELnqVo9BkXXZQoK5VKODxzJobnzkWpvx8QoM70KwEfLfMBo9Q3fe+yp9sk\nXWQ4SLvg1AeudHvNOHlqhk8ueNWCs+umReMvDUDzGy\/eh++z4tFg6SaOikd+bcvY28YvrYoYGon2\nXdy5+MXcNpsBb+PyafPvggSN\/xDQ4RFz33iHBwdjuc0c9jUKGZ+2XmvjapO1j6i\/H\/sBzF+3Lpbj\nXK\/XMX\/1ajHiTPfdbDa\/MFceeck+G1+dq8x1POYNy+Y\/ny3DlNfYjFdF3vLkVgHNk0hr1qwB1qyJ\nRWl\/b9cuRBs34vEtW2LgC4yCcKPRiAFxlpQNCUwleKZlNBWDt32qFV12Rbppv7xcGlMoFGpTIVzR\nVw4uZZJvnEfUmWuI3UC5JPUVso80NyU+QA7Z19KNm9SPrS0dt61fCaTpA4C2sdqOPcnOFWG2RdSN\nTxdA8XauHFCbf5tvF6xqoMTml47VJg2I+fqa29cnLnbiauMqC7VJA8u0XWZYZjdTu667TsxPphFn\nfrwtuuACVMgsD1Taz0gDzGmOhYkIy1EU4c1veUvC972f\/SwQJXPmzfbVarX2L8mFJo8KaJ6MiqI2\nOPfU63jpjh3Axo14zOQCC0Br1KmUDdMXh4Ul69Yl8pZN2yfOPhvdf\/d3CX8u4NHCsxYKAeAVr3yl\nys70QfePTVL0T7NqoVTPL3p1ZY615MsoZB9J7eh7n722zuaHHnO0\/WK2QplrHNIFU3t82NrZQNxn\nG9ovv3Dz7\/T0d74Th+6+O2afFr58+0zTLqu9VtrtzGssodsY4jPrGFwpOrtuvVUEZzOPs6\/v7z3w\nQKZjisuXimEDVFdfecOybyy07jXCIib3fvaziKIo9lAtUOQtTwUV0DxF9NIdOxBt2oRfXn11G+gk\noO1EygZ\/H0URll18sQi77XSMK69EBUlolCBd6oOPg8oF3VppYNY1Bkn0wlYqlWILr7j88HoplzlU\naSHS9llox24bgyZdRaOQ7eK22iiaDZp9bTSQrYGOkU98Aqece26sTLNMsU95QqENVEz57z772UH+\nbL73btuGeQxA5q1aFYs2h8B\/Grs0wKy5ObHZu6Z8s4mCM2238PzzsfOWW2K2p+3aFXsfEl2mkoIu\n2l9XJH+2cltb7U2h9N81Fppe8fK+Psw7dCjRj4kkG18mLaPIW578KqB5sioajTYb\/f7OnYg2bkSp\nVBLhmUZINfAs2bng2QXKtXIZh2fOxMjs2Sht3gw6cgmsJKCyAboEJNQ2BLoA4Lvf+U5z\/8IPc1Qh\nfZgoBG\/Do9F0pa8oitDo7s50MyCNg2uso8+0Xgu4kn72X\/8V1NaXauEbi22bbNuXR3TVNp5Og12I\nvRZ+sownBjGVCrqEm4apAMv8ZijLvtx5yy047ZJLMI3NIbzoggti4OzLZ+bSjMk2I4rvta9MKtf2\nlQWWoyjC2Rs2YPHISKKvT3\/qU4iEaRzXBD6XUmhiqoDmySwBnF+2axe+t2ABlm\/cGANn\/mAehWcK\noRSiKchweDblHJY5\/NTKZexYtKhZtnlz20aCXRs8c9uQyHNWsLVBObdLG9lO7K\/WRdLmY8+NNwIZ\n+tOMhSoLQHcy+qwZR4i91C5kf\/CLsiaqHCIfiGaBqSzwlxVMjf7fT3+q8iP53XfrrYlosxa8NH2m\n9WNrY2tPU7ry+nx5v8PXXotZH\/wgTtm\/P2a36IIL2q9t+cw+\/7Y+gfh5YbLDsil7wW9+k+jvU\/fc\ng4jM4V6kYkw9FdA82SWA88t378YDvb1YTqLO5kJug2cJooEkBJmHCpddfDGIkQhO+085pRlZ7u8f\nHSvqFtLyAAAgAElEQVT8sJsGnn1w3Gl4lsaSBZ6jqJnLTDOj65YlwDsFz2l82z4TVxqNz5fR3L4+\nJC+Vura2MWja0bba40i6CGe5CQhVHtHdUCAejz6NTsyYge4jR9rv569ejT23364eV142rjb0tW3G\nk07BMtWhj34UhwYG0Lt9e2LZ7Sw3Fq4bKRuYhnzeEwWWAeCvhWWy77n77vb0ckUqxtRVAc1TQQI4\nv2JoCN+dPx+lUqkNz6VSCY9v2RLLyaRAaKLItpSNMy+5ZBQe4E6b+PWSJai05lx2gYgLQiTooicw\nPmWXFp6zgK3ZPy4bPpYs8Ey196abAMvFtlKpdAyeufJM30g75tMffDBRJt3w2cZks7HJ1jbEZx5Q\nafOTB1ylsevkNmn8m\/qR66\/H\/NZMBC54C\/WvtXG18+WbS310ApZjqlYxNDCAuTt2YNqxY23b03\/9\n65jZd7\/zHfVYs4JuVh8aANa0lWDZvI6iCG9697sTY7n7k59E7cSJdnS5SMWYuiqgearIfOnJBfuV\ne\/YAQBueS6USzt6wIRZZbjbR\/QcDQfr66LRp2DVvHgCg6x\/+AWXIMG3E2\/vgQ4IrPtWd70IjQf4r\nX\/UqZxtJ0hR7XFnhecF558VuTOotKLb54Bdm\/tn5FmTxKa\/os\/TelGWB\/Z8++mjMt60fI1vk2GYv\nKQ9g1IC9Rqe+733Yf+edYl3eQJ3V37Of85zgPl12Nmij0ebQPtJuo\/lZXqsxh2Vq09+PPVGEU\/7m\nb9rpGt3HjwePNRSKtdvssnVtrxaWbccQ\/aNlyzduxFnDw5jGAhefvOsu1E6cKPKWTxIV0DzVpIRn\nDs4hMuB0cMYM7D311GZha65lnuIhRRnpCcnWvw3ONPBM7aitC+LTaCzg2bTZc+ONCX+adgZGXbnS\nIUCdR\/TZdxOl9aeVLXplg2lun0daRZ7R5yiKsO+OO3AqWR00ja8Q+7TjzNvWFnUEgD23396ONhsZ\ncNZGrEPEUyzSwnJeNzVaWOZ2Bz\/yERwcGMDiJ59M2C9euxbP3HST2E8nYZnX8zLbd9o2jiywDKD5\n0N+BA5h\/+HCi3+PHjxd5yyeRCmiequogPD+xcGHT9T\/8Q7usBPdJ2wWuBmBswJIVnikg2aLaRt\/5\n9rdH9x10wJQ3PEtzqmqitSF907a+FeVsUJ32hmAsbmg0ch1r3I5v11jmJ49XH3mBps\/u0Uce8bbN\nsm0+wJKkWWXRaLLCckzVKrB2bazol89+NhBFWNwqf+amm6z70rWPNeN1AbKrH\/4+LSxTWw7Oyzdu\nxIuffjox5pYBVsk1haaoCmie6qInldaF3sAzADzQ2xsD53q5jIMzZgAA9s2a1WpG4Hrz5jYwdFlg\nrNltcv5lCufjAc\/cn0Yh0c9ORZ7pkrd5wTN972vvAgi68iFXKECb9668ZEDOZ85Drgixb5xajWXq\nRx7+Oxm91rQP9Td0222JJed716zB7o9\/vP0+BIglpQH5vGE5j8g815k\/\/7l15oyIwTPgz0vWjFcD\ny74H\/cx77ss1DurTvJYA+03nnIMe4XjZdvvtRXT5JFUBzSeThBPXKwD8f4sX47\/mzEHv0aOYc+IE\nhq64AqUSmWmjVGrn15bIqn++mTZ4lLc5BHvUl6du0OntJGWBZxv0uMBXC5lZ4FmKMrvaSz5C2\/Iy\nrR\/ADyBm3uk0KSn0tesXgkcfeUQ8tvNI8XAdf7Z95uo374hpqO88YTwvXyFg5xtHrVYTH7zLAspZ\nQD5PWA7tNwSsF69dmwDm4z096GZzOgPNlI2nW+livj59sJwlqizZ+WBZE1k2de8SHvhrGRXR5ZNY\nBTQXwu\/v2IHfB3DHHXdgCEBXvd6GlBg8A7GyKLLPtBFygrdFTaW5oV3tJR\/cD5XLp2ljAyENQKeB\nZ74vaZTZ54MqNKKZZvs0ss0c0NXVlUsuta+OK89cads4skTes\/Rz2sqVGB4czKUPW59Z9ZznPje1\n73q9rgJIW7R56LbbVP3Y4CxEaUDX1l\/eUWXJ5qxf\/CL2\/lvf\/GbzxcAATm\/NR0zbLVm3DgCw\/YYb\nRJ++fWgDW82+97UNhWXe7uwNG\/DSHTsS42gZyeWFThoV0FyorZUrVwJowjOA9pzM5n9XV1cb7vhP\nZjT1gkJiCEBr4JnW29pLPqgfVw63FBnn5aGAqe3XLDDQPrl3d4u2LvHx5pGGkjYK7ZJZVtZIurGg\nUM0f8LKNT\/rsJFtfCkgnlGeUdyyUx3i1+b6aeYtDxiOBs02+aGiI8oLlvKPKvnprWkZ\/P7ZfcQVm\nj4xgNln9zvjzwTMvs0WQNdBNz6MS7LpgWXrPy5Zv3IglBw5gqbAsdstQLi90UqmA5kIJGXi+8847\nUavV2pFeA880+uyLBvuirCGpGxw+08KzFNG11fkgLASg6Yma7xe6IpfR0A03AJZxasQvRq7Pgrej\n6lQUmorClfSAonm97Ec\/SrT1\/fRu\/FEI98GYZrvGCrZtGh4cxNwUCyjkEf0MqXN9Pj\/64Q9jc4+n\nhWSNTLQ5T0jmbccKljU3IxqQjqIIL\/mzP3P7r1ZxAMCBgQHM27ULPceOJfxweKb927YtTa4ykDye\nXJFnDSwbYH7e0JCYv9wylssLnXQqoLmQVe8jU1oNDg4mltiW4JnCrYlSm9eui5UNQKToM4dPKRrs\nak\/7tckFUhpY53a8zhdlPT59euqosU2+Pm3SRqE7mX5g2+c\/+uEP1f5oqkgeY61U0p8+xzrvWbPA\nRtY+0vrqVATeRJup\/\/mrV8fSNLL2nXX8Ie19oKyNNnO7GWwatW98\/etyu8svxxAADAxg8Y4d6BKO\nKQrPWaLK3M61GIkr6iw98GfsG40GVmzahCiK8Pu7diXG0DKWywudtCqguZBKZknQO+64IwbNHJ4B\n\/8k7BNiMQlI3KGRyex\/k8XoO667xpIXLheef314eulQqoV6pYPjaaxPt84JnIBnZnahpHCHjCek3\nBHRs\/vIE0bTiY5iocGzz1wlgpj6lh9nGM6Ic6sMH1VpQttlqfCcgt78fRz\/wAZTL5XbUmdsYeAaA\np66\/PnVU2TZlHK1zRZNNOZ0hw4AyADssNxva6wqdtCqguVCQTOrG4OBgG5Zp3rMBMFfE2RV9dkWd\njVypG1p4NjZctH9XRNkG17b3vA9X3a7rrkPJsh\/oBSEvgOYXmTRpHJobkE5IAnUNjISMJw\/AHivN\nW7UKe7dtA9AZINVKAqAXvfjFHevLpv3XX5\/IbV5w3nmxKeg0\/vPYlxo\/PqDWgrb2\/Qve9CbVGLiP\n4SuvHC0bGEDv7t2YxtI2TLul69e33z+5datokzWqLMFyo9GIlRtYbkQRXr57d2IcpBN7XaGTXgU0\nF0olE3keHBxsAzONOlOgk6IMPEeZi4OhBNNStJenIHDIpPrjP\/kTa7+2PqTtcEWneVs+hkUXXJCI\nMps2dJtD86+zKE0ax1gA9Jk\/\/nHQOLTjsSnNONPAle8YG4sxZPGXtr8fPPRQqnZpwDHUf577UBst\nTgvKPkh22fDUjP\/82tdi0OjzFUURossvxy4AGBjAnAMHMOPQIVQsecfLLr449t5AtBQdjvVhee+K\nNpuosikvYLlQHiqguVAm0bQNCZ6BUfDiEWEpqkujzzR\/2QUwaVM3bOInaG7vAjMXXPP60y+8MNHv\nruuuA4T94oJjftG13VykUZo0jhCAzjo+jXzQYeu\/U2Cdph+bpKWj8+4jTx+d7Ndmt\/vjH8eC886L\nldFocycg2TWmNJAb6kMDu0vWrUO3YzET13spENK4\/HLsA7BvYAAAMHd4GD3Hj7cBWhqTgWha\/0Qr\nNc0XVablNO2C17\/MlYLRNHLXFypEVEBzoVxk0jaAJkBTKDYwDUB8cJDCoCb6bIt+hsKzJAk8ebRa\nAmgJaiX4ttXTKLNUx8uk7ba11UZffXLtB1cbX79po9BpI5Wu\/n3y5XH77LNIG4lMC4DjBcVcIePQ\n2nJwjqIIvWvWqOZBDx1HGlBOEz1PA8pU84eGYu+\/9h\/\/kQBIV8QXsMyA0d8PANgLoP6hDyGKIjyL\nLEPtGncURTjzkku8Y+cQDQANBswFLBfqhApoLpS76HzPJuJsoJFGbm1RZlou5SRLU89J0VUOY5r5\nko1ssJcWoHk9fVDGlPEoszQWX\/60NF5eJm0fr\/eJX0DTTmenGVfvmjXAOOcKG4WCpS3638kxTBT4\npXLlM6fdpyEy+a15SBsZzgrKoRCstYmiCC9+61sxZ\/9+Vb9iVNmRd0zfl\/7+71EC8EQUAQMDiKII\n80dGUK7VUKnXUSEL1rj8SK95RNn8FSkYhTqpApoLdUwcnnnKhgEJW\/SZA7Ev+iwBihR9dkWabWBt\ni\/zawJEDNPV1+oUXgvZeKpWw4+abnX3Z6kKgWLsvqbSwl3Y2Dlu\/vG8NlHQ6zSOLxhJkQ1a\/Gy89\n9OCDXoDJss8k0Nt1662JZeoXnn++Ndrs6l8LzrQ8TTSZl2UBaVonAbMPlrkP11ikSHB0+eUAgCFT\nf8UVzfLW+8XDw5h+4oQTlGtdXWhEESrkJuh4qYSXDg3hh\/PmycBcgHKhHFVAc6GOi8IzjwpL0Wfb\ne8AffaYP\/\/ng2SVNRJn7sT1AR33RJ8mNjk2bFgTrUp15L22z1Ib7DcnrDdl3Pv8+P0ZnPfxwkL1N\nExms0ypk9bvx0FhExrUrD0rgvOC887xpGpqorlSXZdtdsJ0GlF36j69+1drGB8tSBNjlq13XSuMA\nmp\/f0wCiK66wRpTN35nDw9jf3Y1nZszAb+\/bh1fv3AkATWAuALlQh1VAc6ExE52urtFotCPPPOLM\n0zQoQPuiz9LsGdSHeR1FEb78pS\/hz974RrE9t+Wwbcsz5nnUdLu4falUwvGeHuy55ppYfSisU0kX\nNx+0Shc330qOXKH+XRFvjR78\/vfbF8g8otp8XIVk5RUxT+snJGpra3tk1ixMP3gwVscjzi4wzDq2\ntKCt8e+6eTDtpFmDskaVbeDM2\/J5lxM++vtFUDZtG40GHm+97kuxGmahQllVQHOhMRedrs6cEKW8\nZ17Oc6GNfNFnHqWm9lzUhr43fmzltL0RB+il69cjIuW1ri7s3rIFYA8qUl8agOZjkLYpBIrpmKl\/\nXx9cGnvbjUDe6R1ZfWX1O5GUF\/hq\/b\/kpS9N7SMLHNs0smULui65BNOERU9C+ssDkn39+vrQtKV6\nxV\/9VaLs3\/\/t36x9pY0q20CZv+dTxtFFSKgNLS9gudB4qoDmQuMmevK74447ACCW9yylavCotJTS\nIYnDJ4VeoxNkjmSjvAD6jIsuSpTv2LoVdASu+ZFdAM37omO3SYJiVxsp2u7rIy1Iu16HKE+Y1vjN\ns4\/QMfD3fLnoTvfvUm3aNFSOH2+\/f\/D732+\/1qZVZB0Db7f3mmuw6IILYuULzz8fO2+5xdlO26fP\nzhcRzguSebuZR454xxISVdas2Mfb2UBZgnADzAUoF5ooKqC50IQQTd2QQJn\/1et1a1oHIIMlTbWg\n0GvUXaslwNB1gXJFqmmfJsJMdWTWLBFEfekdpg9bO27H5bup0IAxB1ppP9sUCtIA8Kyf\/CRRxh88\n9MkVpQ+Vpr9OR3M7qbzHToEZCAflPG6aJB87b7klAc6LLrgAO2+5JTjqrBmna7vTQLQGkqle9eY3\nJ+y+8uUvW\/254Nh1gysBtnktvZdA2fRZwHKhiaYCmgtNKNGTpFmqWwvQdClvCt7mpKyZFs3kWkvw\nC4RfwCkwU397P\/rRWE6uCyb5BdU2Swdtp8l55v347GxtskZe04C0rz33kwa8QvZhVp8aufqVFvDI\nA35DfEi2v\/+yl3WkL187ra9jPT2JNI2F558fm80mpF9enyViHLJdvja2KLMWlPl7FyjTMqlOiizT\nJa\/r9TpWKxbsKVRoPFRAc6EJKwrQ27ZtawNHuVz2AjRP56A5zoAdoA008\/xoLg66msizsd9+ww2A\nUO4S9e2b3k26IGd5sI\/X+yDfduFOE5HmMx0AwP\/93vfaNxyucdvGomkX0lbjK6tPl2zA1Mm+0sr1\n2WXpWwOwUtnea67B4rVrE3WL165tg7N2m33RaU3EOOQz9H3utPzVb31rov2Xv\/SlhD335QJl3oZD\nsGRnA+UoioqocqFJoQKaC00KrVq1qv3aB9BAfB5oqc72c+ifvu1t+Mp99yWAmV4waBqIZGMA0SwR\na8pr5TJ2bt3aBmaXD+qHv+b2kh8Obnk82GfaSRBta+OCb+mmZCzyjblsNwEh7bOOYSzUqXHl7TcN\nAPvqXG123HwzFq9dmwuwamxc77XbZgNYW5tZLMr8pX\/9V8ARIdb0wwGZg7KtLoriKRj03F6o0ERX\nAc2FJp3oSfb2229vR1ErlUoCMqWIMwXQz3\/uc3gLi8JQmOMXEQ7ctij0GRddFEvLqJXL2HHtte0o\nGx2DDaDpWLh4e27vA2kbbNu2yTceLi1IcxsNuNii+mmVNaI8USGZzz881uN82ctf7qxPA7ham1Cw\nfuammxIRZxNt9kWQqV\/tNoVAt\/a1zR+fVhOQI8E2H1I+sy2iTMt4Xb1eb\/8v0i8KTVYV0FxoUoue\nfClAl8vlxAwbNoDmogulUPEUD1sUmgIz0IwwP7NgQXtqORs08rQQVz9Se+5bioBL\/WtTTfLI8fWl\ndnAtf\/TRTP1p+0mjtFHtvH0a7bzllkQ6y0QDeg0sSvahdmm2e8fNN4sPBj5z003WPkPA3wff2gi0\nLzJNy97453+eqP\/iF74QizLzdlK0OQ0om4hyFBWpF4WmjgpoLjRlJAF0qdScws4H0EbTajW85a1v\nxefuu081Q4MPmEulEp7u7QX6+xNpGRIsc7DVRqF96R1ZFQq7NltN5NylB777Xat\/13hc4\/JpvEF7\nLJXX+CQ\/D3z3u+1fWtL06wPEtGOj75+56SacfuGFsfrFa9fimZtuygV4XW1oWUhk2nbj\/xd\/+ZeJ\n8i\/cf3\/sM7CBModf3r8Nog0oF2kXhaaqCmguNCXFAZrCMwVo6QG54+Uy6vV6rI7nMfP3Z116aRMK\niR8DiY3+fpQckCfBshEv53AZmiIggavk03bR9tnxcUk+bHZ5\/ixvA900AJwWJPOEbS4tiGmWiM57\nDADwile+MsjeZxP6GYT6oeUjs2dj9shIrP70Cy\/E0zfeKNpro9yu8jwgmeoP3v525xgk\/z5Qts2n\nbKLJRdpFoZNBpWiihz4KFcpREkCXSiWcc+65MbuHlizB41u2JB4m5K8B4FmXXSamPOybNQv7\/\/f\/\nTuQU2x7Wk8okW5uNzack1xiy2PlsNeMzNovXrsWKn\/40Vvedb3872F+IQsY3UcVTNEKgOa+0iVe+\n6lWJsu9+5zvqmx6tQv1pIXT23\/4tTtm\/P1G+\/YYbgsYQkqbhKtfYUnD+qze9KdHmnz\/\/+Zg\/Dr+2\n9xI8G1gu0i4KnWwqIs2FTirxSMi2bdvEaHMURTh7wwb88uqrrYumLN+4sWnL2u4\/5RTsnzUL2Ly5\nnTtIH0CUfJn3POVCSuWgkWFNPrIr6iulePgeLATkBVf4a1\/utG18xoYDszQOV2S5U1FlbpOmH02b\nrPEMHiEcC9nG\/J1vf7udFpA3GHO7PEB65J\/+CY2\/+RvMOXAgVr50\/XpEUSTCs8u3bUzSZ+MCZyky\nzO3eJCxi8vnPfa59LpIix+a\/C5SLtItChYpIc6FCoyIgc6xcxsMLFgAAHrvqqlhKx4pNm0iTOPTu\nmzUL+z78YWtUmrdzRZJ98KuJSttsbWWSNIvCGH9pI7VS2Wte+9pE2be\/9S3VWEKkucnohFzpLVnE\nH2ZzLQ0dKk1U9dWveU2izve5hd6s5A3SNv+9Gzei59gx0X77DTcEpWmERpKlMfn6+KN3vhOnsPHe\nd++97de2Jayl+Zjr9XoblIu0i0KFmiqguVAhKgZMI93d+K9581pVcgoCff3ra65pv6awydM74l26\ngdkH3j5fmjqfX6m+U6kgRq993eti77\/1zW8G9TcWypqKkqfMqVxarMM2A0QnxKGZAnNIKkOaiHQI\nTGtt537gA5h5+LBo\/9T117f9Ud\/Sa20ZB2YfmJsyPnWm0Wc\/85lYW9uUcEU0uVAhv4r0jEKFqKIo\nBs5zTpzA84eG8MN58xIpEaVSCUe6u\/H0nDno+od\/aDZorUjYdBVPo9CAME\/hsNn6Fljhr3lahyst\nw5dC4YreSWN1pYLw8bmkSe2w2WkVCrohEGjrK++4hTTncJ5Km15ha9cJ0E3bRrLd85GPYA+AxZde\nikprrmFjt3T9evzmuuusbUMB2VZG67jt6885JxFdNvrMpz+NiK28R30bSC4e4itUSKci0lyokCQL\nPD3Q29uqLuGxuXOb4LN5cxsWDQhposzchtvyOqmdq0xqq23nq9P6p3ahqRt\/8Id\/GKv7xte\/ruqL\n+xrLdIvxlivabJaF7mTf\/NcBAPjmN77RsfQLbp8mJ91Vx8c074MfbK+ux21\/c911QakWmrHzfGNe\n9lfvehemtUCe61P33CO2K9IuChVKryLSXKiQJHMBYyD0iqGhdv1Pb7utOftGrYZyudwyb9o3Go3E\nlHVGUiTa2JgLmwv4pCWxpYeCeDSat5F8mTqbT01UWhq3LeJn8\/eHf\/RHCVszHm2aSQhI2aTN587a\nz0RU1nQJoHWjE5DL6xtP1qixVK8Zm3m\/5yMfwZ6BAZy+axcq9XrM7oyLLmqDsyuNwjU+CZKB5Pe0\n0Wjgz977XhGY7\/7kJ40RoiiKpV00Gg2sWbMm0aZQoUI6FZHmQoVy1G233YZyuYxSqWRdUAWQIVoq\n10aoqVxRXU3EV\/PgYp6+Jf3xn\/xJ7P3Pfvu3Y\/PkajVeD\/l1qu+QGwG+SEcn85qjKEr8MgAA\/\/m1\nrwX5SBthzuJX22\/M5oorMG\/\/fsw6ckRsS59tsI3VBsiA\/GCe+X\/2hg34nT17MPv48UQfn7zrLkRR\nVCxZXahQh1RAc6FCHdRtJhpdKsWi0Ryes6RwuB4ypJKiptqora1emwLhithKbTk0\/8dXv5rKd14a\n61SPPMShGZDBOWuusZH064CB5jxSLzQ2WeFYU09tlmzYkIg4c19PXHstABmEeTnvg9ot37gRURTh\npTt2iGMb3LatHVkuosmFCnVGBTQXKjTG4tFoDsMcgjWAbItQ0zJJkq\/QCGmIb63Nn7z+9bH3Lmj2\nSdP\/WCgNeGedY3nJunWx92mi9RpFUYQ\/+uM\/jpWFfGaay5BmX4SkQPj8aPOTccUVmD8ygp7jxxMP\nCtJ2v\/rYxxJ10oN9tHzFpk143u7d6LHkLZOG3m0qVKhQdhU5zYUKjbF4FIhGo81\/WzqHBNGAnB\/N\n5YrI0lxqehE3711gnDZ6R3Ous0YAbWPztQ31GxKZt\/U1XnGKPCKtNvFfBkL9pkmRyPq5+j4P15hi\n4+jvx64oAgYGAACL9u7F9BMnErbPuuwycfy\/vPpqrNi0KQHMvzs8jDnEj2Ug7vpChQrlqiLSXKjQ\nBNTtt98eW+bblRMdMguHLYocmnrhg8cs0d0\/e+MbE2X\/9pWveP3lHTXuZBSafxadAuql69cnymyr\n2UnSjof\/MvDVf\/930U8eOcghfnxl2rQO19gSaRcDA4iiCGfv3u30w\/+b18\/et88Py81GfptChQrl\nqiLSXKjQBBR\/eIdHo2laR6PRSAA1jRwbSa9tqR\/AaPSaQ4IUjeavXfUuQJFA9dHly8UZQ3hfGpAK\nSTXJA2Bt\/aV56I221eqp669PgHMe20V9vP4Nb0jUu1IpUj14F2jjikhrUjgAeRtU+ceXX44oivDY\nFVdg4cGDaEQRuut1lOt1dLdmtJDaPmf\/fpxaq9k21XTori9UqFBHVUSaCxWapNq2bZs1pYNDse0h\nQE002mUr2dnKXCketO6Nf\/7nsfpHzj4bv7nuuqDIr9Y2azQ5NP+7k7KdyqVos1nJLqve8Kd\/mij7\n8pe+pGqbV7RYKgtJ45DqJWC2PaBH7bmNed34X\/8Lv7V3b7v8lXv2WMdkGWiYfaFChTqiItJcqNAk\nFV\/q1jxgaACZR6NNmZENZtOAM4\/6ShFbF1C7wMa14ppNNls+Bq1PLQxPxBhE2mhz3hFpjU0ekWNX\nnQS9rrQJycYFyDFQbq20t2bNGuA970kOTjqmJuDxU6hQoVEV0Fyo0BSR7QFDGomWFgjhDxn6IDdN\nJNr2QKFUxuX6qT90Zo+sKRF5+fONu9PwbRbiyNIX\/0UAAL70r\/8qgp925gsNNLvKfak6tgiyz1cQ\nIGtVAHKhQpNOBTQXKjRFJV3A6XR3AESQ7gRQ8za26Pab3vzmRHstNEt9S\/CUJc0jK8x2YkYPjZ7c\nuhXLLr44qJ8043B9Vr48Z1e5Jrrsy5W29c\/bSfMpN0gucipALlSo0JRQAc2FCp1E8l3oBwcHY5Bb\nr9fFHGnzWqrLAs5cP1q2rP2go6TQhwpd5VJ9HukbeT5cmCVSfqKrqz2PMNCMNj+5dWsqX3\/wjnck\nyr9w\/\/2AA0xt5b4cZW36hja1wwfIPJLcaDSKVfUKFSoEoHgQsFChQkqZafA4KPtm4nA9jMjbvZ3B\n2A\/POKO9KIQtks19pKnP0k77QGTeCj11R1GEsy69NFFuVqzT+pd+Dbj\/n\/9ZtHVFd6U+0jzQJz14\nJ\/Vtg2f6uoggFypUyKUi0lyoUCGVfNG2wcFBALo5pM1\/H1D\/8uqrY9FLX960Vlr45qCmTQHR9qdR\nnnENHm0GwlYdfPNb3iKWu6Zi4+XSa+m95MsGyK5oMo0a84dnCxUqVChERaS5UKFCHZeZHs8XpT6X\nzTLwqXvucUaYqdICtM0+bZRZU58WvtPY8jZnbNqUAOdfX3ONt\/3r3vtezDt8OFF+3733Bs+AQcsk\nIOb2rpSKAogLFSo0ViqguVChQuMqk\/YBAH0MfO76xCeCHiSUlAdAa\/zkAdlcWeDYpQV\/93c45ejR\nWJlJg5HaL9+4ES\/avj1R\/plPf9rZDwVcKX+YvrZFiAGgr6\/P2U+hQoUKjYUKaC5UqNDEEgXLKPoZ\nZZAAAAEkSURBVBKj1IA9paPpwv9gng+Os+Yqh0B0p+DYpeUbN4p+Ht+yJfb+zeeeix4WmQaAe+6+\n2zoWV\/4wLyuAuFChQpNFBTQXKlRoymlwcBCNRqO9pDhd6IXr\/2\/v3m0YhKEoDJ\/CEsoAVKnSZIdI\nrOMVmIERPACZhWFCASVykyIP5WEbk4KC\/F+DwMa485ElrnND9FxbTjWQWP+lJeiWlosL9d\/XtXaJ\nY5sP46jyYzf64dy2X2OHrgRiAFtCaAaAGa8hfMlOdE6QjvmljnLqHe+9jDHv900jSToOw\/P5qe91\nKQqV0xT7cHJeALBVhGYAWJG1VlVVBdu6rpNzbuUZKXykcwjLBYA\/RmgGANzEwjPLBABQpxkAcEc4\nBoCo+O\/nAAAAACRJV45teld4xMBjAAAAAElFTkSuQmCC","width":303}
%---
%[text:image:002c]
%   data: {"align":"middle","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAArElEQVR42mP4\/\/8\/AwgnJiYapKam\nfgfS\/ynBUDMMYOYywBggiYcPH\/6nFIDMAJmFYQHIdmoBqFm4LZjrYPd\/gpoyGIPYVLeA5j4gbEAS\nHJNlwZYtW\/93dHTixDCDQTRMDKRn8FhATBDNmTOH\/CAiBI4cOQI2HETTLBW9fv2a\/FRUtPXVf\/We\nuyRhkB6iLQBp2HLvP0kYpGfUglELhpMFNM9oNKlw6FHp06TZAgAoeVix9Bg9oQAAAABJRU5ErkJg\ngg==","width":24}
%---
%[text:image:9460]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+S\nvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+\nE+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoq\nKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\n\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzv\nAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0\nDShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoC\nB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1\neqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btH\nJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCO\nriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq\n7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjt\nVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/A\nSgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysr\nFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNx\nk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh\n5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElF\nTkSuQmCC","width":22}
%---
%[text:image:99f7]
%   data: {"align":"baseline","height":23,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAEp0lEQVR42t2a208TQRTG67OJxvv9\nfiGoD6LGgPiCGo1G\/wljTKDl1pL00RuKIKCIIiKg6ItB8IJ38K4Panz13RcfSBBBQQHRek4ys\/kY\npu1uu2132+Sku6eb6X7zmzlz5ux6PEn6lJaWbi0uLu4mGyLrJWvMz8+f4UmnjxA5QhZS7HNZWdnU\ndNE5hQR9EsLGioqKWuj7kRRbUlJSmS40D4Co4yD+rfAPEdW5rhdKQj4KQQM4J0n0DhjCVW4XuR9o\nHlV\/J98rSZVsnmuF0nz8oNIsLCxcFQwGp4vf86AjzrhV5D4dTTq+Tr8d0VD95fP5Frpx2L4XAgYl\nTQpMq+n8DxKm4+0wV6tdJZIo7YWbPwbi26QfqdL5S+H\/7SqqdMPvJE2iOFPOTUEzpM5bpEodUOMW\nkXs06yb7r6qZEc5dOn\/hKqqQCESiOYkqic4Ff62jRZKg3XCzJ0B8q0akjupzSZU6aZGTl5Q34kZ\/\nBgKB2ezzer3LOMcNJ5SpSvJIlY7POTWn3QUBpRzEt0QQqYvMzxxNlW7staRJQ3gO0Bw1IdSYz9Qx\n28Bf57QhuxNu7iSIbzYhclKEpvZ6HElVR5OOl5qkGZEqdcB5p9DMC0OzyYJIXaTuFr4R6rzFTkj3\njK1WHDRDarSmdnPAX59qkbkQaU+B\/7IqglM7+g4qVqu5rhzaeeoIqpC2RaVJN52pGfYbdFRlW0iV\nrr2QcppkFSC+MUxUNSt0AlU6f5JSqpCuGcUtv9+\/JExZ05JQpErf2eC\/mOxIi4v6aRDfEGGdtCJU\njeCPhW+Uk5BkCu2xQjNGoQZVWl+30Pk\/4W9I1tzM0RWfeVhFyXysCp0QyaHoPUZtLU\/G3OxWadIf\nL+Dilt1CMZrTtZuB6qVE7zezdUVnDv0mctlYhKpUHyaFKoR6SzTjEYr\/pVBtTDhNLDZz0m1ydxKr\nUHWdfiCp+ny+FYmgKUP8sHx8YJamDUK1VDnVtHs5wSFTDeLrLOw34xGqrtf3E0IVgoBRiiwoKJhv\nlqZNQjEubIKOb7Jr3TQaxeIyF6+sbMFsEKqu2\/ZShQZVmsPJFhqOKrVzxTaaWFTW7SNNCD3IlUI0\n8h2KYXOO63eXpErtrYwnCHWpNDniWqVpsxlUacnLAhDNsa6bWTqaolIQSrFVwei6FxdVGlZ3baY5\nSNav2KCdVLlYblXkRqB5FnqvOlYKNgWjUJjsTEIZpzbXWIm0d9QCMlfneI\/oFKFKhoZgWs0GIP7z\nv+qDHu7BeOZVAoSqWZqEM+73+9eaodlpN80ECjXiBwLih87Rnoith4vrgGZlvJEyQUJVqrdNUaUL\nOmRp0U6a8uUMssNo\/BDYBqHDnKlppt21qDTxwQ7vGhywbkbrxBrN1Bsny9DRbFcLxV6vdxad\/3C6\nUJyryvRrU7OgdfBjPYivcIHIkCYX79BSpZObLqYZkSq\/kicjaqZ04oMcrpS7SGRIzeJIy60JVDk6\nSZpcbRdDeRr5v2hyU6fbV\/l8VVlXm5lcX0wJsTveYpMVw14PzMOGNBQqE4h+3M8x5hti3UwH64S5\n2y6D0YALA49Z6+P3hCXiDLH2fEsjgd+ZKr9wyRr\/A+UKAPezYlA8AAAAAElFTkSuQmCC","width":23}
%---
%[text:image:1f0d]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:8e0b]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:4936]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:15b7]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:7ceb]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:editfield:7d9c]
%   data: {"defaultValue":"[1; 0.5; 0.3]","label":"Initial Velocity Direction","run":"Section","valueType":"MATLAB code"}
%---
%[control:editfield:975f]
%   data: {"defaultValue":"[0; 0; 1]","label":"Magnetic Field Direction","run":"Section","valueType":"MATLAB code"}
%---
%[control:button:769f]
%   data: {"label":"Run Simulation","run":"Section"}
%---
%[text:image:2c0a]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:dropdown:74da]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","The particle moves in a straight line","The particle experiences no force","The particle moves in a circular path","The particle comes to rest"],"items":["\"??\"","\"A\"","\"B\"","\"C\"","\"D\""],"label":"Your Answer: ","run":"Section"}
%---
%[control:dropdown:33c7]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","The particle moves in a straight line","The particle experiences no force","The particle moves in a circular path","The particle comes to rest"],"items":["\"??\"","\"A\"","\"B\"","\"C\"","\"D\""],"label":"Your Answer: ","run":"Section"}
%---
%[control:dropdown:4fbb]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","The particle moves in a straight line","The particle experiences no force","The particle moves in a circular path","The particle comes to rest"],"items":["\"??\"","\"A\"","\"B\"","\"C\"","\"D\""],"label":"Your Answer: ","run":"Section"}
%---
%[text:image:4597]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:dropdown:96d4]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","1.","2.","3.","4."],"items":["\"??\"","\"1\"","\"2\"","\"3\"","\"4\""],"label":"Your Answer","run":"Section"}
%---
%[text:image:52ac]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF4AAABMCAYAAADkzAD+AAABzklEQVR42u3cXXGEMBSG4ZWAhJWA\nBCQgAQcgAQkrIRIqAQlIiAQcUDJDO91OKFBCOCe8F9\/1Js8y+TkJPMZxfJD4AQF44AnwwBPggSfA\nA0+AB\/4tdV1nU4pEk4uEdw2bMkwZE46RCN8njv6VXBr8eJMUkuGLlCZL4IEHHnjggQceeOCBBx74\nUI16Tml+1zT2FJWA31+JfK1srzv3xwAfFn1rUWzQ\/vRLgu92FpYcfgb8sUZUZ9aygT+n7p4Bf03d\nvQD+fw0oDsK3wAN\/q6GmBP6ayfUJfPzlZMdyMv5Tr3r3KgneFcbsDviKkkHYes3HCrhNoUQstSzs\nru61nqpkpR2cgxDggY8OPy8jj15MtfOwlAG\/7YdN4IufVtPy8hJ4z8QZKj3wf6\/Xz7zy3ADv\/8Hm\nZPgO+LjDzFtHFCRJeN4IAR544M\/uCC8YAw888MADDzzwwIuFn2voKX9Rw0iFv8OGpgEe+G943xjd\nK\/1C0muhL5nIyXXhyp2qtzMW+tBLPbtd+2xVqwQ91\/bg+I7xft4SGJTAG23HhVteLMgVwFttR4Vb\nzg\/NPAFLjrrhccsTpC2lZviSXepFtZp5om0VpbpVkYwADzwBHngCvIh8Ag3lAhMN2JymAAAAAElF\nTkSuQmCC","width":30}
%---
%[control:editfield:8819]
%   data: {"defaultValue":"[1; 0.5; 0.3]","label":"Initial Velocity Direction","run":"Section","valueType":"MATLAB code"}
%---
%[control:editfield:7b8e]
%   data: {"defaultValue":"[0; 0; 1]","label":"Magnetic Field Direction","run":"Nothing","valueType":"MATLAB code"}
%---
%[control:button:09a6]
%   data: {"label":"Run Simulation","run":"Section"}
%---
%[text:image:1909]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:63e6]
%   data: {"label":"Generate Problem Statement","run":"Section"}
%---
%[control:button:150d]
%   data: {"label":"Show Hint","run":"Section"}
%---
%[control:editfield:126c]
%   data: {"defaultValue":" ","label":"Current (A) = ","run":"Nothing","valueType":"MATLAB code"}
%---
%[control:button:1ded]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:071e]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:6611]
%   data: {"label":"View Current Loop","run":"Section"}
%---
%[text:image:3625]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:editfield:4455]
%   data: {"defaultValue":"[0,0,1]","label":"Point Location","run":"Nothing","valueType":"MATLAB code"}
%---
%[control:button:48df]
%   data: {"label":"Run","run":"Section"}
%---
%[text:image:23c7]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:spinner:9add]
%   data: {"defaultValue":8,"label":"Number of Segments","max":100,"min":4,"run":"Nothing","runOn":"ValueChanging","step":1}
%---
%[control:button:028c]
%   data: {"label":"Run","run":"Section"}
%---
%[text:image:4c15]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:721c]
%   data: {"label":"Run","run":"Section"}
%---
%[text:image:53a0]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:2b51]
%   data: {"label":"Show configuration","run":"Section"}
%---
%[text:image:77fd]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF4AAABMCAYAAADkzAD+AAABzklEQVR42u3cXXGEMBSG4ZWAhJWA\nBCQgAQcgAQkrIRIqAQlIiAQcUDJDO91OKFBCOCe8F9\/1Js8y+TkJPMZxfJD4AQF44AnwwBPggSfA\nA0+AB\/4tdV1nU4pEk4uEdw2bMkwZE46RCN8njv6VXBr8eJMUkuGLlCZL4IEHHnjggQceeOCBBx74\nUI16Tml+1zT2FJWA31+JfK1srzv3xwAfFn1rUWzQ\/vRLgu92FpYcfgb8sUZUZ9aygT+n7p4Bf03d\nvQD+fw0oDsK3wAN\/q6GmBP6ayfUJfPzlZMdyMv5Tr3r3KgneFcbsDviKkkHYes3HCrhNoUQstSzs\nru61nqpkpR2cgxDggY8OPy8jj15MtfOwlAG\/7YdN4IufVtPy8hJ4z8QZKj3wf6\/Xz7zy3ADv\/8Hm\nZPgO+LjDzFtHFCRJeN4IAR544M\/uCC8YAw888MADDzzwwIuFn2voKX9Rw0iFv8OGpgEe+G943xjd\nK\/1C0muhL5nIyXXhyp2qtzMW+tBLPbtd+2xVqwQ91\/bg+I7xft4SGJTAG23HhVteLMgVwFttR4Vb\nzg\/NPAFLjrrhccsTpC2lZviSXepFtZp5om0VpbpVkYwADzwBHngCvIh8Ag3lAhMN2JymAAAAAElF\nTkSuQmCC","width":30}
%---
%[control:button:083c]
%   data: {"label":"Show demonstration","run":"Section"}
%---
%[text:image:569d]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+S\nvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+\nE+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoq\nKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\n\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzv\nAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0\nDShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoC\nB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1\neqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btH\nJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCO\nriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq\n7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjt\nVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/A\nSgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysr\nFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNx\nk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh\n5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElF\nTkSuQmCC","width":22}
%---
%[text:image:7600]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:dropdown:4f75]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","Solenoid","Toroid"],"items":["\"??\"","\"Solenoid\"","\"Toroid\""],"label":"Drop down","run":"Nothing"}
%---
%[control:button:5935]
%   data: {"label":"Generate Problem","run":"Section"}
%---
%[control:dropdown:27c0]
%   data: {"defaultValue":"\"??\"","itemLabels":["??","A","B","C","D"],"items":["\"??\"","\"A\"","\"B\"","\"C\"","\"D\""],"label":"Answer:","run":"AllSections"}
%---
%[text:image:4786]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:08ca]
%   data: {"label":"Generate Problem","run":"Section"}
%---
%[control:editfield:0b04]
%   data: {"defaultValue":"\"\"","label":"Total Current (A)","run":"Section","valueType":"String"}
%---
%[control:button:8d25]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:04e1]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:button:47d8]
%   data: {"label":"Show Hint","run":"Section"}
%---
%[control:editfield:93c5]
%   data: {"defaultValue":"\"\"","label":"Your Answer: ","run":"Section","valueType":"String"}
%---
%[control:button:1bfb]
%   data: {"label":"Check Answer","run":"Section"}
%---
%[text:image:205c]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[control:editfield:62cd]
%   data: {"defaultValue":"\"\"","label":"Your Answer:","run":"Section","valueType":"String"}
%---
%[control:button:5586]
%   data: {"label":"Check Answer","run":"Section"}
%---
