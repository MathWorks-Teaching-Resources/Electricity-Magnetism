%[text] %[text:anchor:TMP_emwave] # Electromagnetic Waves (Solution Version)
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%[text] From the radio waves carrying your favorite music to the light illuminating this screen, electromagnetic waves are fundamental to modern technology and our understanding of nature. In this script, we'll explore how time-varying electric and magnetic fields create waves that propagate through space, carrying energy and information across vast distances.
%[text]{"align":"center"} 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%%
%[text] %[text:anchor:H_BF646A47] This live script is intended to be used with the code hidden. On the **View** tab of the MATLAB toolstrip, in the **View** section, select **Hide Code**.  Alternately, select **Hide Code** using the icon ![live script code hidden icon](text:image:002c) at the top right of the Live Editor pane.
%[text] ![Lightbulb mark](text:image:9460) Although the code is hidden, some interactivity requires familiarity with MATLAB. If you need more instruction, consider taking [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted), a free 2 hour online tutorial that teaches the essentials of MATLAB.
%[text] %[text:anchor:H_8F8A032D] ![Warning symbol](text:image:99f7)   For an optimal experience, follow the instructions and steps in the given sequence. Proceed to a new section only after completing the preceding one. Some sections depend on variables created in prior sections and will generate errors if run out of order.
%[text] The ![Try this icon](text:image:1f0d)  and  ![Exercise icon](text:image:8e0b) icons refer to two different types of interactive activities that you will find in this script. The ![Try this icon](text:image:4936)  usually indicates an interaction where you will explore the visualization of some concept introduced in this script. The ![Exercise icon](text:image:15b7) interactions are designed to challenge your understanding of those concepts and may be used for grading and completion checks by your professor.
%%
%[text] %[text:anchor:TMP_motivation] ## Why Electromagnetic Waves Matter
%[text] Every time you use your smartphone, watch TV, or simply see the world around you, you're experiencing electromagnetic waves in action. These waves are the foundation of:
%[text] - **Wireless communication:** WiFi, cellular networks, radio, and satellite communications
%[text] - **Medical imaging:** X-rays, MRI scanners, and thermal imaging
%[text] - **Vision:** Visible light is an electromagnetic wave
%[text] - **Energy transmission:** Microwave ovens, induction heating, and solar power
%[text] - **Scientific exploration:** Radio telescopes observing distant galaxies \
%[text] Understanding electromagnetic waves helps us design better antennas, optimize wireless networks, develop new medical technologies, and explore the universe. Let's start by understanding how these waves emerge from the fundamental laws of electromagnetism.
%%
%[text] %[text:anchor:TMP_maxwell] ## Maxwell's Equations: The Foundation
%[text] In previous lessons, you explored static electric and magnetic fields. But what happens when charges accelerate or fields change with time? James Clerk Maxwell discovered that time-varying electric and magnetic fields are intimately coupled through a set of equations that bear his name.
%[text] Maxwell's equations in free space (vacuum) are:
%[text]{"align":"center"} %[text:anchor:M_gaussE] $ \\nabla \\cdot \\vec{E} = \\frac{\\rho}{\\varepsilon\_0} \\qquad \\text{(Gauss's law for electricity)}$
%[text]{"align":"center"} %[text:anchor:M_gaussB] $ \\nabla \\cdot \\vec{B} = 0 \\qquad \\text{(Gauss's law for magnetism)}$
%[text]{"align":"center"} %[text:anchor:M_faraday] $ \\nabla \\times \\vec{E} = -\\frac{\\partial \\vec{B}}{\\partial t} \\qquad \\text{(Faraday's law)}$
%[text]{"align":"center"} %[text:anchor:M_ampere] $ \\nabla \\times \\vec{B} = \\mu\_0 \\vec{J} + \\mu\_0 \\varepsilon\_0 \\frac{\\partial \\vec{E}}{\\partial t} \\qquad \\text{(Ampère-Maxwell law)}$
%[text] Where:
%[text] - $\\vec{E}$ is the **electric field** (V/m)
%[text] - $\\vec{B}$ is the **magnetic flux density** (T)
%[text] - $\\rho$ is the **charge density** (C/m³)
%[text] - $\\vec{J}$ is the **current density** (A/m²)
%[text] - $\\varepsilon\_0 = 8.854 \\times 10^{-12}$ F/m is the **permittivity of free space**
%[text] - $\\mu\_0 = 4\\pi \\times 10^{-7}$ H/m is the **permeability of free space** \
%[text] The key insight is in [Faraday's law](internal:M_faraday) and [Ampère-Maxwell law](internal:M_ampere): **a changing magnetic field creates an electric field, and a changing electric field creates a magnetic field**. This mutual generation allows electromagnetic disturbances to propagate through space as waves.
%%
%[text] %[text:anchor:TMP_waveeq] ## The Wave Equation
%[text] In regions without charges ($\\rho = 0$) or currents ($\\vec{J} = 0$), we can combine Maxwell's equations to derive the **wave equation**. Taking the curl of Faraday's law and substituting Ampère-Maxwell law yields:
%[text]{"align":"center"} $ \\nabla^2 \\vec{E} - \\mu\_0 \\varepsilon\_0 \\frac{\\partial^2 \\vec{E}}{\\partial t^2} = 0$
%[text] Similarly, for the magnetic field:
%[text]{"align":"center"} $ \\nabla^2 \\vec{B} - \\mu\_0 \\varepsilon\_0 \\frac{\\partial^2 \\vec{B}}{\\partial t^2} = 0$
%[text] These are wave equations with wave speed:
%[text]{"align":"center"} %[text:anchor:M_speedlight] $ c = \\frac{1}{\\sqrt{\\mu\_0 \\varepsilon\_0}} \\approx 3 \\times 10^8 \\text{ m/s}$
%[text] This is the **speed of light**! Maxwell's equations predicted that light itself is an electromagnetic wave—one of the greatest unifications in physics.
%%
%[text] ![](text:image:28df) **Info.** The realization that light is an electromagnetic wave united optics with electricity and magnetism, showing they are all aspects of the same fundamental force. This discovery led directly to radio, television, radar, and all modern wireless communications.
%%
%[text] %[text:anchor:TMP_planewave] ## Plane Wave Solutions
%[text] The simplest solution to the wave equation is a **plane wave** traveling in a specific direction. For a wave traveling in the $+z$ direction, the electric and magnetic fields can be written as:
%[text]{"align":"center"} $ \\vec{E}(z,t) = E\_0 \\cos(kz - \\omega t + \\phi) \\hat{x}$
%[text]{"align":"center"} $ \\vec{B}(z,t) = B\_0 \\cos(kz - \\omega t + \\phi) \\hat{y}$
%[text] Where:
%[text] - $E\_0$ and $B\_0$ are the **amplitudes**
%[text] - $k = \\frac{2\\pi}{\\lambda}$ is the **wave number** (rad/m)
%[text] - $\\omega = 2\\pi f$ is the **angular frequency** (rad/s)
%[text] - $\\lambda$ is the **wavelength** (m)
%[text] - $f$ is the **frequency** (Hz)
%[text] - $\\phi$ is the **phase constant** (rad)
%[text] - $c = \\frac{\\omega}{k} = \\lambda f$ is the **wave speed** \
%[text] Key properties of electromagnetic plane waves:
%[text] - $\\vec{E}$ and $\\vec{B}$ are **perpendicular** to each other
%[text] - Both are **perpendicular** to the direction of propagation (transverse wave)
%[text] - They are **in phase** (reach maximum and minimum together)
%[text] - The amplitudes are related by $E\_0 = c B\_0$ \
%[text] ![](text:image:7ceb) **Try.** Explore how electromagnetic waves propagate through space. Adjust the frequency and observe how it affects the wavelength. The animation shows the electric field (red), magnetic field (blue), and direction of propagation.

VisualizeEMWave(frequency=1,... %[control:slider:emfreq]{"position":[19,20]}
    showSnapshot=false) %[control:checkbox:snapshot]{"position":[17,29]}

function VisualizeEMWave(opts)
arguments
    opts.frequency (1,1) double = 1  % Frequency in arbitrary units
    opts.showSnapshot (1,1) logical = false
end

c = 3e8; % Speed of light (m/s)
f = opts.frequency * 1e9; % Convert to GHz
omega = 2*pi*f;
k = omega/c;
lambda = 2*pi/k;

% Spatial grid
z = linspace(0, 3*lambda, 300);

if ~opts.showSnapshot
    % Animation
    figure(Position=[100 100 900 500])
    
    % Time loop for animation
    for t = linspace(0, 2/f, 60)
        clf
        
        % Calculate fields
        Ex = cos(k*z - omega*t);
        By = cos(k*z - omega*t);
        
        % Plot electric field
        plot3(z*1e9, Ex, zeros(size(z)), 'r-', LineWidth=2, DisplayName='E field')
        hold on
        
        % Plot magnetic field
        plot3(z*1e9, zeros(size(z)), By, 'b-', LineWidth=2, DisplayName='B field')
        
        % Plot wave direction
        quiver3(mean(z)*1e9, 0, 0, lambda*0.3*1e9, 0, 0, 0, ...
            'k', 'LineWidth', 2, 'MaxHeadSize', 1, DisplayName='Propagation')
        
        % Formatting
        xlabel('Position z (nm)')
        ylabel('E field (V/m)')
        zlabel('B field (T)')
        title(sprintf('Electromagnetic Wave: f = %.1f GHz, \\lambda = %.1f cm', f/1e9, lambda*100))
        grid on
        box on
        view(45, 20)
        xlim([0 3*lambda*1e9])
        ylim([-1.5 1.5])
        zlim([-1.5 1.5])
        legend(Location='northeast')
        
        hold off
        drawnow
        
        if t == 0
            pause(1) % Pause at the beginning
        end
    end
else
    % Snapshot at t=0
    figure(Position=[100 100 900 500])
    
    t = 0;
    Ex = cos(k*z - omega*t);
    By = cos(k*z - omega*t);
    
    plot3(z*1e9, Ex, zeros(size(z)), 'r-', LineWidth=2, DisplayName='E field')
    hold on
    plot3(z*1e9, zeros(size(z)), By, 'b-', LineWidth=2, DisplayName='B field')
    quiver3(mean(z)*1e9, 0, 0, lambda*0.3*1e9, 0, 0, 0, ...
        'k', 'LineWidth', 2, 'MaxHeadSize', 1, DisplayName='Propagation')
    
    xlabel('Position z (nm)')
    ylabel('E field (V/m)')
    zlabel('B field (T)')
    title(sprintf('Electromagnetic Wave Snapshot: f = %.1f GHz, \\lambda = %.1f cm', f/1e9, lambda*100))
    grid on
    box on
    view(45, 20)
    xlim([0 3*lambda*1e9])
    ylim([-1.5 1.5])
    zlim([-1.5 1.5])
    legend(Location='northeast')
    hold off
end
end
%%
%[text] ![](text:image:6f0d) **Reflect.** Notice that the electric and magnetic fields oscillate perpendicular to each other and to the direction of travel. This is what makes electromagnetic waves **transverse waves**. Also observe that as you increase the frequency, the wavelength decreases—they are inversely related through $c = \\lambda f$.
%%
%[text] %[text:anchor:TMP_spectrum] ## The Electromagnetic Spectrum
%[text] Electromagnetic waves span an enormous range of frequencies, from radio waves with wavelengths of kilometers to gamma rays with wavelengths smaller than atoms. Despite their vastly different properties, they are all described by the same Maxwell's equations.
%[text] ![](text:image:7ceb) **Try.** Explore different regions of the electromagnetic spectrum. Select a type of electromagnetic radiation and observe its frequency, wavelength, and typical applications.

category = "Visible"; %[control:dropdown:spectrum]{"position":[11,18]}
ShowSpectrumInfo(category)

function ShowSpectrumInfo(category)
% Electromagnetic spectrum data
spectrum = struct(...
    'Radio', struct('fmin', 3e3, 'fmax', 3e9, 'app', 'Radio/TV broadcasting, wireless communication'), ...
    'Microwave', struct('fmin', 3e9, 'fmax', 3e11, 'app', 'Radar, satellite communications, microwave ovens'), ...
    'Infrared', struct('fmin', 3e11, 'fmax', 4.3e14, 'app', 'Thermal imaging, remote controls, heaters'), ...
    'Visible', struct('fmin', 4.3e14, 'fmax', 7.5e14, 'app', 'Human vision, photography, optical communications'), ...
    'Ultraviolet', struct('fmin', 7.5e14, 'fmax', 3e16, 'app', 'Sterilization, fluorescence, astronomy'), ...
    'X-ray', struct('fmin', 3e16, 'fmax', 3e19, 'app', 'Medical imaging, security scanning, crystallography'), ...
    'Gamma', struct('fmin', 3e19, 'fmax', 3e22, 'app', 'Cancer treatment, astronomy, nuclear physics'));

if isempty(category) || ~isfield(spectrum, category)
    disp('Select a category from the dropdown above to explore the electromagnetic spectrum.')
    return
end

data = spectrum.(category);
c = 3e8; % Speed of light

% Calculate representative values
f_mid = sqrt(data.fmin * data.fmax); % Geometric mean
lambda_max = c / data.fmin;
lambda_min = c / data.fmax;
lambda_mid = c / f_mid;

% Display information
fprintf('\n=== %s Radiation ===\n', category)
fprintf('Frequency range: %.2e to %.2e Hz\n', data.fmin, data.fmax)
fprintf('Wavelength range: %.2e to %.2e m\n', lambda_min, lambda_max)
fprintf('Typical wavelength: %.2e m\n', lambda_mid)
fprintf('Applications: %s\n\n', data.app)

% Create visualization
figure(Position=[100 100 800 400])

% Frequency scale (logarithmic)
f_range = logspace(log10(3e3), log10(3e22), 1000);
y = ones(size(f_range));

% Plot full spectrum
semilogx(f_range, y, 'k-', LineWidth=1)
hold on

% Highlight selected region
f_selected = logspace(log10(data.fmin), log10(data.fmax), 100);
area(f_selected, ones(size(f_selected)), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none')

% Add labels for all regions
regions = fieldnames(spectrum);
for i = 1:length(regions)
    region = regions{i};
    d = spectrum.(region);
    f_center = sqrt(d.fmin * d.fmax);
    text(f_center, 1.5, region, 'HorizontalAlignment', 'center', 'FontSize', 10, 'Rotation', 45)
end

xlabel('Frequency (Hz)')
title('Electromagnetic Spectrum')
ylim([0 3])
yticks([])
grid on
hold off
end
%%
%[text] ![](text:image:727c) **Exercise 1.** A WiFi router operates at a frequency of 5 GHz. Calculate the wavelength of the electromagnetic waves it emits. Enter your answer in centimeters.
%[text] %[text:anchor:M_ex1soln] **Solution:** Using $\\lambda = \\frac{c}{f}$ where $c = 3 \\times 10^8$ m/s and $f = 5 \\times 10^9$ Hz, we get $\\lambda = 0.06$ m = **6.0 cm**

CheckExercise1("6.0") %[control:editfield:ex1ans]{"position":[16,21]} %[control:button:ex1btn]{"position":[22,23]}

function CheckExercise1(answer)
if isempty(answer)
    warning('Please enter your answer above.')
    return
end

% Convert answer to numeric
answer = str2double(answer);

if isnan(answer)
    warning('Please enter a valid numeric answer.')
    return
end

% Correct answer
c = 3e8; % m/s
f = 5e9; % Hz
lambda_correct = c / f * 100; % Convert to cm

% Check answer
tolerance = 0.1; % cm
if abs(answer - lambda_correct) < tolerance
    fprintf('Excellent! The wavelength is %.1f cm.\n', lambda_correct)
    fprintf('This is calculated using λ = c/f = (3×10⁸ m/s)/(5×10⁹ Hz) = %.2e m = %.1f cm\n', ...
        c/f, lambda_correct)
else
    warning('Not quite right. Remember to use λ = c/f where c = 3×10⁸ m/s. Make sure your answer is in centimeters.')
end
end
%%
%[text] %[text:anchor:TMP_energy] ## Energy Transport and the Poynting Vector
%[text] Electromagnetic waves don't just oscillate—they carry energy. The **Poynting vector** $\\vec{S}$ describes the directional energy flux (power per unit area) of an electromagnetic field:
%[text]{"align":"center"} $ \\vec{S} = \\frac{1}{\\mu\_0} \\vec{E} \\times \\vec{B}$
%[text] The Poynting vector points in the direction of wave propagation, and its magnitude gives the instantaneous power per unit area. For a plane wave, the time-averaged power per unit area (intensity) is:
%[text]{"align":"center"} $ I = \\langle S \\rangle = \\frac{1}{2\\mu\_0 c} E\_0^2 = \\frac{1}{2} \\varepsilon\_0 c E\_0^2$
%[text] Where $E\_0$ is the amplitude of the electric field.
%%
%[text] ![](text:image:28df) **Info.** The intensity of sunlight reaching Earth's surface is about 1000 W/m². This corresponds to an electric field amplitude of about 870 V/m—roughly the voltage between a car battery's terminals, but spread over a meter!
%%
%[text] ![](text:image:7ceb) **Try.** Visualize how the Poynting vector represents energy flow in an electromagnetic wave. The color intensity represents the magnitude of the energy flux.

VisualizePoynting(amplitude=1,... %[control:slider:poyntamp]{"position":[22,23]}
    frequency=1) %[control:slider:poyntfreq]{"position":[14,15]}

function VisualizePoynting(opts)
arguments
    opts.amplitude (1,1) double = 1
    opts.frequency (1,1) double = 1
end

c = 3e8; % Speed of light
E0 = opts.amplitude;
f = opts.frequency * 1e9; % GHz
omega = 2*pi*f;
k = omega/c;
lambda = 2*pi/k;
mu0 = 4*pi*1e-7;

% Create spatial grid
z = linspace(0, 2*lambda, 200);
t = linspace(0, 1/f, 50);

figure(Position=[100 100 900 600])

for idx = 1:length(t)
    % Calculate fields
    E = E0 * cos(k*z - omega*t(idx));
    B = E0/c * cos(k*z - omega*t(idx));
    
    % Calculate Poynting vector (magnitude)
    S = 1/mu0 * E .* B;
    
    % Normalize for visualization
    S_normalized = S / max(abs(S)) * 100; % Percentage
    
    % Create plot
    subplot(3,1,1)
    plot(z*1e9, E, 'r-', LineWidth=2)
    ylabel('E field (V/m)')
    title(sprintf('Electromagnetic Wave and Energy Flow (t = %.2f ns)', t(idx)*1e9))
    grid on
    ylim([-E0*1.2 E0*1.2])
    xlim([0 2*lambda*1e9])
    
    subplot(3,1,2)
    plot(z*1e9, B*1e9, 'b-', LineWidth=2)
    ylabel('B field (nT)')
    grid on
    ylim([-E0/c*1e9*1.2 E0/c*1e9*1.2])
    xlim([0 2*lambda*1e9])
    
    subplot(3,1,3)
    plot(z*1e9, S_normalized, 'g-', LineWidth=2)
    xlabel('Position z (nm)')
    ylabel('Energy Flux (%)')
    grid on
    ylim([-110 110])
    xlim([0 2*lambda*1e9])
    
    drawnow
    
    if idx == 1
        pause(0.5)
    end
end

% Display intensity calculation
I = 0.5 / mu0 / c * E0^2;
fprintf('\nTime-averaged intensity: %.2e W/m²\n', I)
end
%%
%[text] ![](text:image:6f0d) **Reflect.** Notice that the Poynting vector oscillates at **twice the frequency** of the electric and magnetic fields. This is because $\\vec{S} \\propto \\vec{E} \\times \\vec{B}$, so it depends on the product of the fields. The time-average gives the steady energy flow rate.
%%
%[text] %[text:anchor:TMP_polarization] ## Polarization
%[text] The **polarization** of an electromagnetic wave describes the direction of the electric field vector. For a linearly polarized wave, the electric field oscillates in a single plane. Circular and elliptical polarization occur when the electric field rotates as the wave propagates.
%[text] For a wave traveling in the $+z$ direction:
%[text] - **Linear polarization:** $\\vec{E} = E\_0 \\cos(kz - \\omega t) \\hat{x}$
%[text] - **Circular polarization:** $\\vec{E} = E\_0 [\\cos(kz - \\omega t) \\hat{x} \\pm \\sin(kz - \\omega t) \\hat{y}]$ \
%[text] ![](text:image:7ceb) **Try.** Explore different polarization states. Observe how the electric field vector changes direction as the wave propagates.

VisualizePolarization(polarization="Circular") %[control:dropdown:polar]{"position":[26,34]}

function VisualizePolarization(opts)
arguments
    opts.polarization (1,1) string = "Linear"
end

c = 3e8;
f = 1e9; % 1 GHz
omega = 2*pi*f;
k = omega/c;
lambda = 2*pi/k;

z = linspace(0, 2*lambda, 100);
t = linspace(0, 2/f, 80);

figure(Position=[100 100 900 600])

for idx = 1:length(t)
    clf
    
    switch opts.polarization
        case "Linear"
            Ex = cos(k*z - omega*t(idx));
            Ey = zeros(size(z));
            titleStr = 'Linear Polarization (E field in x-direction)';
            
        case "Circular"
            Ex = cos(k*z - omega*t(idx));
            Ey = sin(k*z - omega*t(idx));
            titleStr = 'Circular Polarization (E field rotates)';
            
        case "Elliptical"
            Ex = cos(k*z - omega*t(idx));
            Ey = 0.5 * sin(k*z - omega*t(idx));
            titleStr = 'Elliptical Polarization';
            
        otherwise
            Ex = cos(k*z - omega*t(idx));
            Ey = zeros(size(z));
            titleStr = 'Linear Polarization';
    end
    
    % Plot 3D view
    subplot(1,2,1)
    plot3(z*1e9, Ex, Ey, 'r-', LineWidth=2)
    hold on
    
    % Add arrows at several positions
    n_arrows = 8;
    z_arrows = linspace(z(1), z(end), n_arrows);
    for i = 1:n_arrows
        Ex_arrow = cos(k*z_arrows(i) - omega*t(idx));
        Ey_arrow = sin(k*z_arrows(i) - omega*t(idx)) * (strcmp(opts.polarization, "Circular") + ...
                    0.5*strcmp(opts.polarization, "Elliptical"));
        quiver3(z_arrows(i)*1e9, 0, 0, 0, Ex_arrow*0.3, Ey_arrow*0.3, ...
            0, 'r', 'LineWidth', 1.5, 'MaxHeadSize', 2)
    end
    
    xlabel('Position z (nm)')
    ylabel('Ex')
    zlabel('Ey')
    title(titleStr)
    grid on
    view(45, 20)
    xlim([0 2*lambda*1e9])
    ylim([-1.5 1.5])
    zlim([-1.5 1.5])
    hold off
    
    % Plot end-on view (looking along propagation direction)
    subplot(1,2,2)
    plot(Ex, Ey, 'r-', LineWidth=1)
    hold on
    
    % Add animated point
    z_point = z(round(length(z)*0.3));
    Ex_point = cos(k*z_point - omega*t(idx));
    Ey_point = sin(k*z_point - omega*t(idx)) * (strcmp(opts.polarization, "Circular") + ...
                0.5*strcmp(opts.polarization, "Elliptical"));
    plot(Ex_point, Ey_point, 'ro', MarkerSize=10, MarkerFaceColor='r')
    quiver(0, 0, Ex_point, Ey_point, 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 1)
    
    xlabel('Ex')
    ylabel('Ey')
    title('View Along Propagation Direction')
    axis equal
    grid on
    xlim([-1.5 1.5])
    ylim([-1.5 1.5])
    hold off
    
    drawnow
    
    if idx == 1
        pause(0.5)
    end
end
end
%%
%[text] ![](text:image:28df) **Info.** Polarization is crucial in many technologies. Polarized sunglasses reduce glare by blocking horizontally polarized light reflected from surfaces. LCD screens use polarization to control which pixels appear bright or dark. Satellite communications often use circular polarization to maintain signal strength regardless of receiver orientation.
%%
%[text] %[text:anchor:TMP_applications] ## Applications: Dipole Antenna Radiation
%[text] One of the most practical applications of electromagnetic waves is in antennas. A simple **dipole antenna** consists of two conducting rods. When an oscillating current flows through the antenna, it radiates electromagnetic waves.
%[text] The time-averaged radiated power per unit solid angle for a short dipole antenna is:
%[text]{"align":"center"} $ \\frac{dP}{d\\Omega} = \\frac{\\mu\_0 c}{32\\pi^2} I\_0^2 \\left(\\frac{\\pi L}{\\lambda}\\right)^2 \\sin^2\\theta$
%[text] Where:
%[text] - $I\_0$ is the current amplitude
%[text] - $L$ is the antenna length
%[text] - $\\lambda$ is the wavelength
%[text] - $\\theta$ is the angle from the antenna axis \
%[text] ![](text:image:7ceb) **Try.** Visualize the radiation pattern of a dipole antenna. The color and distance from center represent the intensity of radiation in that direction. Notice that dipoles don't radiate along their axis.

VisualizeDipoleRadiation(length=0.5) %[control:slider:diplength]{"position":[27,28]}

function VisualizeDipoleRadiation(opts)
arguments
    opts.length (1,1) double = 0.5 % Length in wavelengths
end

% Radiation pattern for dipole antenna
theta = linspace(0, pi, 100);
phi = linspace(0, 2*pi, 100);
[Theta, Phi] = meshgrid(theta, phi);

% Normalized radiation pattern
L = opts.length; % Antenna length in wavelengths
Pattern = sin(Theta).^2 * (pi*L)^2;
Pattern = Pattern / max(Pattern(:)); % Normalize

% Convert to Cartesian coordinates
X = Pattern .* sin(Theta) .* cos(Phi);
Y = Pattern .* sin(Theta) .* sin(Phi);
Z = Pattern .* cos(Theta);

figure(Position=[100 100 800 600])
surf(X, Y, Z, Pattern, EdgeColor='none')
hold on

% Add antenna representation
antenna_z = linspace(-L/2, L/2, 50);
antenna_x = zeros(size(antenna_z));
antenna_y = zeros(size(antenna_z));
plot3(antenna_x, antenna_y, antenna_z, 'r-', LineWidth=4)

xlabel('x')
ylabel('y')
zlabel('z (antenna axis)')
title(sprintf('Dipole Antenna Radiation Pattern (L = %.2fλ)', L))
colormap('hot')
colorbar
axis equal
view(45, 30)
grid on
hold off

fprintf('\nDipole antenna properties:\n')
fprintf('Length: %.2f wavelengths\n', L)
fprintf('Maximum radiation: perpendicular to antenna axis\n')
fprintf('Minimum radiation: along antenna axis\n')
end
%%
%[text] ![](text:image:727c) **Exercise 2.** An FM radio station broadcasts at 100 MHz with a power of 50 kW. Assuming the antenna radiates equally in all horizontal directions (but not vertically), calculate the intensity at a distance of 10 km from the antenna. Express your answer in μW/m² (microwatts per square meter).
%[text] _Hint: The power spreads over a cylindrical surface area._
%[text] %[text:anchor:M_ex2soln] **Solution:** For hemispherical radiation, the area is $A = 2\\pi r^2 = 2\\pi (10^4)^2 = 6.28 \\times 10^8$ m². The intensity is $I = \\frac{P}{A} = \\frac{50000}{6.28 \\times 10^8} = 7.96 \\times 10^{-5}$ W/m² = **79.6 μW/m²**

CheckExercise2("79.6") %[control:editfield:ex2ans]{"position":[16,22]} %[control:button:ex2btn]{"position":[23,24]}

function CheckExercise2(answer)
if isempty(answer)
    warning('Please enter your answer above.')
    return
end

answer = str2double(answer);
if isnan(answer)
    warning('Please enter a valid numeric answer.')
    return
end

% Correct answer calculation
P = 50e3; % W
r = 10e3; % m
% For horizontal radiation, approximate as cylindrical surface
% More realistically, hemisphere: A = 2*pi*r^2
A = 2*pi*r^2;
I_correct = P / A * 1e6; % Convert to μW/m²

tolerance = I_correct * 0.15; % 15% tolerance
if abs(answer - I_correct) < tolerance
    fprintf('Excellent! The intensity is approximately %.2f μW/m².\n', I_correct)
    fprintf('This is calculated using I = P/A where A ≈ 2πr² for hemispherical radiation.\n')
else
    warning('Not quite. Consider that the power spreads over a hemispherical area, A ≈ 2πr². Make sure to convert to microwatts per square meter.')
end
end
%%
%[text] %[text:anchor:TMP_summary] ## Summary
%[text] In this script, you explored the fundamental concepts of electromagnetic waves:
%[text] - **Maxwell's Equations** unify electricity and magnetism, showing how time-varying fields create waves
%[text] - **Wave Equation** emerges from Maxwell's equations, predicting wave propagation at the speed of light
%[text] - **Plane Waves** are the simplest solutions, with $\\vec{E}$ and $\\vec{B}$ perpendicular to each other and the propagation direction
%[text] - **Electromagnetic Spectrum** spans from radio waves to gamma rays, all following the same principles
%[text] - **Energy Transport** is described by the Poynting vector $\\vec{S} = \\frac{1}{\\mu\_0} \\vec{E} \\times \\vec{B}$
%[text] - **Polarization** describes the orientation of the electric field vector
%[text] - **Applications** include antennas, wireless communications, radar, and much more \
%[text] These concepts form the foundation for understanding modern telecommunications, optics, quantum mechanics, and countless technologies that shape our world.
%%
%[text] ## Additional Resources
%[text] To deepen your understanding of electromagnetic waves:
%[text] - Explore antenna design and how different geometries affect radiation patterns
%[text] - Study waveguides and how electromagnetic waves propagate in confined structures
%[text] - Investigate the quantum nature of light and photons
%[text] - Learn about electromagnetic wave propagation in materials (beyond free space)
%[text] - Examine applications in modern wireless communications (5G, WiFi, satellite) \
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%%
%%
%[text] ## Help us Improve
%[text] [Share your feedback](<matlab: ShareFeedback>) to help us improve this module.
% Helper function for checking if values are close
function result = IsClose(val1, val2, tolerance)
if nargin < 3
    tolerance = 0.01; % 1% relative tolerance
end

relative_diff = abs(val1-val2) / max(abs(val1), abs(val2));
result = relative_diff < tolerance;
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[text:image:002c]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:15b7]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:1f0d]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:28df]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:4936]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:6f0d]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:727c]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:7ceb]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:8e0b]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:9460]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
%[text:image:99f7]
%   data: {"align":"baseline","height":0,"src":"","width":0}
%---
