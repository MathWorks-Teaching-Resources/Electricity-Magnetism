%[text] %[text:anchor:TMP_5bf7] # Gauss's Law
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%[text] In [ElectricFieldAndCharge.m](<matlab:open('Scripts/ElectricFieldAndCharge.m')>) we learned about electric field and how to compute them in some simple cases. Gauss's Law is an efficient technique to compute electric field in cases where the charge distribution presents some sort of symmetry. 
%%
%[text] 
%[text:tableOfContents]{"heading":"**Table of Contents**"}
%%
%[text] %[text:anchor:H_BF646A47] This live script is intended to be used with the code hidden. On the **View** tab of the MATLAB toolstrip, in the **View** section, select **Hide Code**.  Alternately, select **Hide Code** using the icon ![live script code hidden icon](text:image:822c) at the top right of the Live Editor pane.
%[text] ![Lightbulb mark](text:image:7b85) Although the code is hidden, some interactivity requires familiarity with MATLAB. If you need more instruction, consider taking [MATLAB Onramp](https://matlabacademy.mathworks.com/details/matlab-onramp/gettingstarted), a free 2 hour online tutorial that teaches the essentials of MATLAB.
%[text] %[text:anchor:H_8F8A032D] ![Warning symbol](text:image:6541)   For an optimal experience, follow the instructions and steps in the given sequence. Proceed to a new section only after completing the preceding one. Some sections depend on variables created in prior sections and will generate errors if run out of order.
%[text] The ![Try this icon](text:image:0656)  and  ![Exercise icon](text:image:1027) icons refer to two different types of interactive activities that you will find in this script. The ![Try this icon](text:image:766c)  usually indicates an interaction where you will explore the visualization of some concept introduced in this script. The ![Exercise icon](text:image:2ecf) interactions are designed to challenge your understanding of those concepts and may be used for grading and completion checks by your professor.
%%
%[text] %[text:anchor:TMP_64d5] ## Introduction
%[text] In this script, we will use a MATLAB Application to practice computing the electric field using Gauss's Law.
%[text] ![Try this icon](text:image:7878) **Try.** To get started with practicing, click the button below to start the application.
GaussLaw
  %[control:button:9d6c]{"position":[1,2]}
%%
%[text] %[text:anchor:TMP_8436] ## **Gauss's Law**
%[text] Gauss’s Law is a fundamental principle in electromagnetism that relates the electric flux passing through a closed surface to the total electric charge enclosed within that surface. It states that the electric flux through any closed surface is equal to the enclosed charge divided by the electric constant ($\\varepsilon\_0$). Gauss’s Law is especially useful for calculating electric fields when the charge distribution exhibits a high degree of symmetry, such as spherical, cylindrical, or planar symmetry. Applying Gauss’s Law, complex electric field problems can often be significantly simplified.
%[text]{"align":"center"} $\\oint\_{\\text{Surface}} \\vec{E} \\cdot d\\vec{A} = \\frac{Q\_{\\text{enclosed}}}{\\varepsilon\_0}$
%[text] with:
%[text] - $(\\vec{E})$: Electric field vector
%[text] - $(d\\vec{A})$: Infinitesimal area vector (points outward).
%[text] - $(Q\_{\\text{enclosed}})$: Total charge enclosed within the surface.
%[text] - $(\\varepsilon\_0)$: Permittivity of free space.
%[text] - (Surface): Is a control Surface, often referred to as Gauss's Surface. \
%[text] ![Try this icon](text:image:2b50) **Try.** View some example of charge distribution and possible Gauss's Surface.
  %[control:button:3174]{"position":[1,2]}
Case = randi(3);

figure
Axes = axes;
view(Axes,3)
axis(Axes,"equal")
switch Case
    case 1
        scatter3(Axes,0,0,0,25,"filled",SeriesIndex=1);
        gm = multisphere(4);
        hold(Axes,"on")
        h = pdegplot(Axes,gm,FaceAlpha = 0.5);
        delete(findobj(Axes,"Type","Quiver"))
        delete(findobj(Axes,"Type","Text"))
        hold(Axes,"off")
    case 2
         xline(Axes,0,SeriesIndex=1,LineWidth=3,Alpha=1);
         gm = multicylinder(3,6,Zoffset=-3);
         gm = rotate(gm,90,[0 0 0],[0 1 0]);
         gm = rotate(gm,90);
         hold(Axes,"on")
         h = pdegplot(Axes,gm,FaceAlpha = 0.5);
         h(2).HandleVisibility = "off";
         delete(findobj(Axes,"Type","Quiver"))
         delete(findobj(Axes,"Type","Text"))
         hold(Axes,"off")
    case 3
        constantplane(Axes,"z",0,SeriesIndex=1,FaceAlpha=0.8);
        gm = multicuboid(3,3,3,Zoffset=-1.5);
        hold(Axes,"on")
        h = pdegplot(Axes,gm,FaceAlpha = 0.5);
        h(2).HandleVisibility = "off";
        delete(findobj(Axes,"Type","Quiver"))
        delete(findobj(Axes,"Type","Text"))
        hold(Axes,"off")
end
xlim(Axes,[-5,5])
ylim(Axes,[-5,5])
zlim(Axes,[-5,5])
zoom(Axes,0.5);
legend(Axes,"Charge Distribution","Gauss's Surface",Location="bestoutside")
%[text] %[text:anchor:TMP_153e] ### 
%%
%[text] %[text:anchor:TMP_3af1] ## **How to Use Symmetry?**
%[text] %[text:anchor:TMP_6ba6] ### **Planar Symmetry**
%[text] ![](text:image:863e) **Definition:** Planar symmetry in electrostatics means that the electric field at any point in space is invariant under reflection across a specific plane.
%[text] System is unchanged by translation parallel to or reflection in a plane; quantities depend only on distance from the plane.
%[text] ![Try this icon](text:image:4fd5) **Try.** View example of distribution with planar symmetry
  %[control:button:9060]{"position":[1,2]}
figure
constantplane("z",0,SeriesIndex=1,FaceAlpha=0.8);
%%
%[text] ![](text:image:326d) **Application.** This symmetry can simplify the expression of the electric field, for example:
%[text] If $\\vec{E} = \\vec{E}(x,y,z)$, and the charge distribution is present a planar symmetry along the $(x,y)$ plane at $z=0$, then:
%[text] - $\\vec{E}(x,y,z) = \\vec{E}(z)$, the field must be only a function of the $z$ (distance from the symmetry plane).
%[text] - $\\vec{E}(z) = -\\vec{E}(-z)$. \
%[text] 
%%
%[text] %[text:anchor:TMP_0f05] ### **Cylindrical/Axial Symmetry**
%[text] ![](text:image:3696) **Definition:** Planar symmetry in electrostatics means that the electric field at any point in space is invariant under rotation around the axis.
%[text] ![Try this icon](text:image:5981) **Try.** View example of distribution with axial symmetry
  %[control:button:29a6]{"position":[1,2]}
figure
Axes = axes;
view(Axes,3)
axis(Axes,"equal")
xline(Axes,0,SeriesIndex=1,LineWidth=3,Alpha=1);
%[text] ![](text:image:67b7) **Application.** Axial symmetry can simplify the expression of the electric field, for example:
%[text] If $\\vec{E} = \\vec{E}(r,\\theta,z)$, and the charge distribution is present, an axial symmetry along the $\\vec{z}$ axis:
%[text] - $\\vec{E}(r,\\theta,z) = \\vec{E}(r)$, the field must be only a function of the $z$ (distance from the symmetry axis).
%[text] - $\\vec{E}(r) = -\\vec{E}(-r)$. \
%[text] ![](text:image:7dbb) **Reflect**. How are those mathematical implications different than the ones from the planar symmetry?
%%
%[text] %[text:anchor:TMP_165f] ### **Spherical symmetry**
%[text] ![](text:image:429b) **Definition:** Planar symmetry in electrostatics means that the electric field at any point in space is invariant under rotation around a point.
%[text] ![Try this icon](text:image:4c22) **Try.** View example of distribution with spherical symmetry
  %[control:button:755e]{"position":[1,2]}
figure
Axes = axes;
view(Axes,3)
axis(Axes,"equal")
scatter3(0,0,0,'filled',SeriesIndex=1);
%[text] ![](text:image:519c) **Application. Spherical** symmetry can simplify the expression of the electric field, for example:
%[text] If $\\vec{E} = \\vec{E}(r,\\theta,\\phi)$, and the charge distribution is present, an axial symmetry along the $\\vec{z}$ axis:
%[text] - $\\vec{E}(r,\\theta,\\phi) = \\vec{E}(r)$, the field must be only a function of the $z$ (distance from the center of symmetry).
%[text] - $\\vec{E}(r) = -\\vec{E}(-r)$. \
%[text] ![](text:image:0e13) **Reflect**. How are those mathematical implications different than the ones from the planar symmetry?
%%
%[text] %[text:anchor:TMP_76ec] ### **How to select the Gaussian surface?**
%[text] Selecting an appropriate Gaussian surface is a crucial step when applying Gauss’s Law to calculate electric fields. The key is to choose a surface that takes advantage of the symmetry of the charge distribution, such as spherical, cylindrical, or planar symmetry. An ideal Gaussian surface simplifies calculations by ensuring that the electric field is either constant in magnitude or perpendicular/parallel to the surface at every point. This allows the electric flux integral to be easily evaluated. By matching the surface shape to the symmetry of the problem, you can efficiently use Gauss’s Law to determine the electric field.
%%
%[text] %[text:anchor:TMP_6ead] ## How to count the charge enclosed?
%[text] When applying Gauss’s Law, a key step is determining the total electric charge enclosed by your chosen Gaussian surface. This involves identifying all the sources of charge, such as point charges, line charges, surface charges, or volume charges, located inside the surface. 
%[text:table]
%[text] | Type of Distribution | Symbol | Unit | Formula for Enclosed Charge |
%[text] | --- | --- | --- | --- |
%[text] | Point Charges | $(-)$ | Coulombs ($C$) | $Q\_{enc} = \\sum\_{i} q\_i $ |
%[text] | Linear Charge Density | $(\\lambda)$ | $(C/\\text{m})$ | $ Q\_{enc} = \\int \\lambda \\, dl $ |
%[text] | Surface Charge Density | $(\\sigma)$ | $(C/\\text{m}^2)\n$ | $Q\_{enc} = \\int \\sigma \\, dA $ |
%[text] | Volume Charge Density | $(\\rho)$ | $(C/\\text{m}^3)$ | $Q\_{enc} = \\int \\rho \\, dV $ |
%[text:table]
%%
%[text] %[text:anchor:TMP_3811] ## **Further exploration: charged sphere**
%[text] This example is used to illustrate a case of discontinuity in the calculation of the electric field using Gauss's Law. Let's go back to the charged sphere example that you might have studied in [GaussLaw](<matlab: GaussLaw>).
%[text] ![Try this icon](text:image:8dfe) **Try.** Show the problem
  %[control:button:4060]{"position":[1,2]}
figure
Axes = axes;
view(Axes,3)
axis(Axes,"equal")
[x,y,z] = sphere(40);
surf(Axes,x,y,z,LineStyle="none");
gm = multisphere(4);
hold(Axes,"on")
pdegplot(Axes,gm,FaceAlpha = 0.5);
delete(findobj(Axes,"Type","Quiver"))
delete(findobj(Axes,"Type","Text"))
hold(Axes,"off")
xlim(Axes,[-5,5])
ylim(Axes,[-5,5])
zlim(Axes,[-5,5])
legend(Axes,"Charge Distribution","Gauss's Surface",Location="bestoutside")
%%
%[text]{"align":"center"} $\\oint\_{\\text{Surface}} \\vec{E} \\cdot d\\vec{A} = \\frac{Q\_{\\text{enclosed}}}{\\varepsilon\_0}$
%[text] ![](text:image:7544) **Case 1:** In the case where $R\_g \> R\_s$, all of the charges are enclosed inside the Gaussian surface.
%[text] Therefore, we found:  $Q\_{\\text{enclosed}} = \\frac{4}{3}\\pi R\_s^3 \\rho$
%[text] There is a spherical symmetry so $\\vec{E}(r,\\theta,\\phi) = \\vec{E}(r)$
%[text] $\\oint\_{\\text{Surface}} \\vec{E} \\cdot d\\vec{A} = E(R\_g) 4\\pi R\_g^2$
%[text] 
%[text] Combining the two previous results, we can compute the electric field at the Gaussian surface as:
%[text]{"align":"center"} $E(R\_g) = \\frac{ \\frac{4}{3}\\pi R\_s^3 \\rho}{\\varepsilon\_0 4\\pi R\_g^2} = \\frac{ \\rho R\_s^3 }{3\\varepsilon\_0 R\_g^2}$
%%
%[text] ![Try this icon](text:image:6203) **Try**. Visualize the field outside the sphere.
  %[control:button:411a]{"position":[1,2]}
Rsup = linspace(1,5);
E = 1./Rsup.^2;
hSup = plot(Rsup,E);
xticks([0 1 2 3 4 5])
xticklabels({'0','R_s','2R_s','3R_s','4R_s','5R_s'})
yticks([0 1])
yticklabels({'0',''})
xlim([0 5])
ylim([0 1.33])
xlabel("Distance from sphere center")
ylabel("Electric Field (E)");
title("Electric Field vs Distance from Sphere Center");
%[text]  
%%
%[text] ![](text:image:6e0a) **Case 2:** Let's see what happens when the radius of the Gaussian surface is lower than the radius of the charge distribution itself $R\_g\<R\_s$.
%[text] There is still some charge within the Gaussian surface: $\\displaystyle Q\_{\\text{enclosed}} = \\frac{4}{3}\\pi R\_g^3 \\rho$
%[text] The integral results from the previous case are still valid: $\\displaystyle \\oint\_{\\text{Surface}} \\vec{E} \\cdot d\\vec{A} = E(R\_g) 4\\pi R\_g^2$
%[text] Therefore, $E(R\_g) = \\frac{ \\frac{4}{3}\\pi R\_g^3 \\rho}{\\varepsilon\_0 4\\pi R\_g^2} = \\frac{ \\rho R\_g }{3\\varepsilon\_0}$
%[text] ![Try this icon](text:image:7ee1) **Try**. Visualize the field inside and outside the charged sphere.
  %[control:button:138a]{"position":[1,2]}
Rsup = linspace(1,5);
E = 1./Rsup.^2;
hSup = plot(Rsup,E);
xticks([0 1 2 3 4 5])
xticklabels({'0','R_s','2R_s','3R_s','4R_s','5R_s'})
xInf = [0 1];
yInf = [0 1];
hold on
plot(xInf,yInf)
hold off
yticks([0 1])
yticklabels({'0',''})
xlim([0 5])
ylim([0 1.33])
xlabel("Distance from sphere center")
ylabel("Electric Field (E)");
title("Electric Field vs Distance from Sphere Center");
legend("Field outside sphere","Field inside sphere")
%[text] 
%%
%[text] %[text:anchor:TMP_3ca9] ## Conclusion
%[text] Understanding and applying Gauss’s Law is a powerful tool for analyzing electric fields, especially when dealing with symmetrical charge distributions. By carefully selecting an appropriate Gaussian surface and accurately determining the enclosed charge, you can simplify complex electrostatic problems and gain deeper insight into the behavior of electric fields. Mastery of these concepts lays a strong foundation for further studies in electromagnetism.
%[text] [⇦ Main Menu](<matlab:open('MainMenu.m')>)
%[text]
%%
%[text] ## Help us Improve
%[text] [Share your feedback](<matlab: ShareFeedback>) to help us improve this module. 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"hidecode","rightPanelPercent":40}
%---
%[text:image:822c]
%   data: {"align":"middle","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAArElEQVR42mP4\/\/8\/AwgnJiYapKam\nfgfS\/ynBUDMMYOYywBggiYcPH\/6nFIDMAJmFYQHIdmoBqFm4LZjrYPd\/gpoyGIPYVLeA5j4gbEAS\nHJNlwZYtW\/93dHTixDCDQTRMDKRn8FhATBDNmTOH\/CAiBI4cOQI2HETTLBW9fv2a\/FRUtPXVf\/We\nuyRhkB6iLQBp2HLvP0kYpGfUglELhpMFNM9oNKlw6FHp06TZAgAoeVix9Bg9oQAAAABJRU5ErkJg\ngg==","width":24}
%---
%[text:image:7b85]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+S\nvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+\nE+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoq\nKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\n\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzv\nAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0\nDShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoC\nB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1\neqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btH\nJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCO\nriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq\n7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjt\nVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/A\nSgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysr\nFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNx\nk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh\n5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElF\nTkSuQmCC","width":22}
%---
%[text:image:6541]
%   data: {"align":"baseline","height":23,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADoAAAA6CAYAAADhu0ooAAAEp0lEQVR42t2a208TQRTG67OJxvv9\nfiGoD6LGgPiCGo1G\/wljTKDl1pL00RuKIKCIIiKg6ItB8IJ38K4Panz13RcfSBBBQQHRek4ys\/kY\npu1uu2132+Sku6eb6X7zmzlz5ux6PEn6lJaWbi0uLu4mGyLrJWvMz8+f4UmnjxA5QhZS7HNZWdnU\ndNE5hQR9EsLGioqKWuj7kRRbUlJSmS40D4Co4yD+rfAPEdW5rhdKQj4KQQM4J0n0DhjCVW4XuR9o\nHlV\/J98rSZVsnmuF0nz8oNIsLCxcFQwGp4vf86AjzrhV5D4dTTq+Tr8d0VD95fP5Frpx2L4XAgYl\nTQpMq+n8DxKm4+0wV6tdJZIo7YWbPwbi26QfqdL5S+H\/7SqqdMPvJE2iOFPOTUEzpM5bpEodUOMW\nkXs06yb7r6qZEc5dOn\/hKqqQCESiOYkqic4Ff62jRZKg3XCzJ0B8q0akjupzSZU6aZGTl5Q34kZ\/\nBgKB2ezzer3LOMcNJ5SpSvJIlY7POTWn3QUBpRzEt0QQqYvMzxxNlW7staRJQ3gO0Bw1IdSYz9Qx\n28Bf57QhuxNu7iSIbzYhclKEpvZ6HElVR5OOl5qkGZEqdcB5p9DMC0OzyYJIXaTuFr4R6rzFTkj3\njK1WHDRDarSmdnPAX59qkbkQaU+B\/7IqglM7+g4qVqu5rhzaeeoIqpC2RaVJN52pGfYbdFRlW0iV\nrr2QcppkFSC+MUxUNSt0AlU6f5JSqpCuGcUtv9+\/JExZ05JQpErf2eC\/mOxIi4v6aRDfEGGdtCJU\njeCPhW+Uk5BkCu2xQjNGoQZVWl+30Pk\/4W9I1tzM0RWfeVhFyXysCp0QyaHoPUZtLU\/G3OxWadIf\nL+Dilt1CMZrTtZuB6qVE7zezdUVnDv0mctlYhKpUHyaFKoR6SzTjEYr\/pVBtTDhNLDZz0m1ydxKr\nUHWdfiCp+ny+FYmgKUP8sHx8YJamDUK1VDnVtHs5wSFTDeLrLOw34xGqrtf3E0IVgoBRiiwoKJhv\nlqZNQjEubIKOb7Jr3TQaxeIyF6+sbMFsEKqu2\/ZShQZVmsPJFhqOKrVzxTaaWFTW7SNNCD3IlUI0\n8h2KYXOO63eXpErtrYwnCHWpNDniWqVpsxlUacnLAhDNsa6bWTqaolIQSrFVwei6FxdVGlZ3baY5\nSNav2KCdVLlYblXkRqB5FnqvOlYKNgWjUJjsTEIZpzbXWIm0d9QCMlfneI\/oFKFKhoZgWs0GIP7z\nv+qDHu7BeOZVAoSqWZqEM+73+9eaodlpN80ECjXiBwLih87Rnoith4vrgGZlvJEyQUJVqrdNUaUL\nOmRp0U6a8uUMssNo\/BDYBqHDnKlppt21qDTxwQ7vGhywbkbrxBrN1Bsny9DRbFcLxV6vdxad\/3C6\nUJyryvRrU7OgdfBjPYivcIHIkCYX79BSpZObLqYZkSq\/kicjaqZ04oMcrpS7SGRIzeJIy60JVDk6\nSZpcbRdDeRr5v2hyU6fbV\/l8VVlXm5lcX0wJsTveYpMVw14PzMOGNBQqE4h+3M8x5hti3UwH64S5\n2y6D0YALA49Z6+P3hCXiDLH2fEsjgd+ZKr9wyRr\/A+UKAPezYlA8AAAAAElFTkSuQmCC","width":23}
%---
%[text:image:0656]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:1027]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:766c]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[text:image:2ecf]
%   data: {"align":"baseline","height":20,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAADUAAAAxCAYAAAB6d+FmAAAC0ElEQVR42u2aO4gTURSGs6Lugo1W\nW2ghgiyCr1VWbRSR9YEgKoKohcQmEDAviYhBIaVbbKEWYi22YidoobUItoqwjSui6wt119Wsj+\/o\nnXAcJslMZpI7AxP4Sbh37pnz3TP3zJ2TyWQS9imVStvRK1G5XL5ZqVRWZpL8MUCf0G+lz+hYIoGI\nyDYPIEc\/i8ViLmkRGkMfWwA5WkD7EwHEutmCs+87ADl6zfHLm4MLhcIqGs7RcV0WoA1xCa3vIkL\/\nCTsX\/w7G2Bka5oIMjlo4M6GBmOTRABHSeirh3S0LzSYQugHHgAPEJG+l7UOXtr6LgQeqYQZdRVf6\nJc5frdfriyKIkOgHQToi1+0XpxGD+ywnhc348a5bICboqLMYmx02784hgRYAOqEzjHWoSIHiABU5\nkG2osECMP9lqC2IFiqS0qSdAtqAM0Ey3QOhUp81iX6F6DtRvKM6xsedA\/YQKCdQgyx0PcrKeQ4WN\nkE4K+LhGb6usQOHQOnnOCb31+WdrNW1TQC22BoW9Ddh9i6bRfNDdNkCH1c59LW0vpc8qFDYfo\/tk\nvMFqtbqM3xdkffgAmseXQ44dM3ba6bcGlc1mh9yzbaK3k\/Y37YAYc9Dl47A+xhoU0dlh7A579I3q\nRx6lbwAd8PAxHlA4V5BF3ea8Z11Ac62e52IDhb1bZuZL+lFdRWtQpflZzj3exlZsIvVc2b7jdW8x\niWSWVL2ng4\/2ofL5\/Ars\/XJdXudN9wC\/R4Ce5PurFH58RN0+FLb2et130D1VVJlCu3zasw9FFC67\ndwboialUnZadQcBJsg+F09ewd9tkwLFcLrckZOTjkSgi3pmkUClUCpVCpVApVAqVQqVQ0UDp6s5I\nHKFMeaz5doufYuYz9bf\/XXmXQaqgcZH4I34pqBd+Qluz\/LpBUF3qCEUol3LgwyQAEbFHUrDxW6OT\nyk7NFEsaMYNpGL9qfoH+AOOEPfJuI6OmAAAAAElFTkSuQmCC","width":22}
%---
%[text:image:7878]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:9d6c]
%   data: {"label":"Start Practice App","run":"Section"}
%---
%[text:image:2b50]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:3174]
%   data: {"label":"View Example","run":"Section"}
%---
%[text:image:863e]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF4AAABMCAYAAADkzAD+AAABzklEQVR42u3cXXGEMBSG4ZWAhJWA\nBCQgAQcgAQkrIRIqAQlIiAQcUDJDO91OKFBCOCe8F9\/1Js8y+TkJPMZxfJD4AQF44AnwwBPggSfA\nA0+AB\/4tdV1nU4pEk4uEdw2bMkwZE46RCN8njv6VXBr8eJMUkuGLlCZL4IEHHnjggQceeOCBBx74\nUI16Tml+1zT2FJWA31+JfK1srzv3xwAfFn1rUWzQ\/vRLgu92FpYcfgb8sUZUZ9aygT+n7p4Bf03d\nvQD+fw0oDsK3wAN\/q6GmBP6ayfUJfPzlZMdyMv5Tr3r3KgneFcbsDviKkkHYes3HCrhNoUQstSzs\nru61nqpkpR2cgxDggY8OPy8jj15MtfOwlAG\/7YdN4IufVtPy8hJ4z8QZKj3wf6\/Xz7zy3ADv\/8Hm\nZPgO+LjDzFtHFCRJeN4IAR544M\/uCC8YAw888MADDzzwwIuFn2voKX9Rw0iFv8OGpgEe+G943xjd\nK\/1C0muhL5nIyXXhyp2qtzMW+tBLPbtd+2xVqwQ91\/bg+I7xft4SGJTAG23HhVteLMgVwFttR4Vb\nzg\/NPAFLjrrhccsTpC2lZviSXepFtZp5om0VpbpVkYwADzwBHngCvIh8Ag3lAhMN2JymAAAAAElF\nTkSuQmCC","width":30}
%---
%[text:image:4fd5]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:9060]
%   data: {"label":"View Example","run":"Section"}
%---
%[text:image:326d]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARL\noIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx\n2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xe\nDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou\n8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP\n2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCC\nM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+C\nWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTw\nV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHK\nQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBt\nArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyX\ndjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC0\n4TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8\nt8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8\nDxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCC\nZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEF\nJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio\n3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+Ec\nB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZg\nf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVa\ntQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:3696]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF4AAABMCAYAAADkzAD+AAABzklEQVR42u3cXXGEMBSG4ZWAhJWA\nBCQgAQcgAQkrIRIqAQlIiAQcUDJDO91OKFBCOCe8F9\/1Js8y+TkJPMZxfJD4AQF44AnwwBPggSfA\nA0+AB\/4tdV1nU4pEk4uEdw2bMkwZE46RCN8njv6VXBr8eJMUkuGLlCZL4IEHHnjggQceeOCBBx74\nUI16Tml+1zT2FJWA31+JfK1srzv3xwAfFn1rUWzQ\/vRLgu92FpYcfgb8sUZUZ9aygT+n7p4Bf03d\nvQD+fw0oDsK3wAN\/q6GmBP6ayfUJfPzlZMdyMv5Tr3r3KgneFcbsDviKkkHYes3HCrhNoUQstSzs\nru61nqpkpR2cgxDggY8OPy8jj15MtfOwlAG\/7YdN4IufVtPy8hJ4z8QZKj3wf6\/Xz7zy3ADv\/8Hm\nZPgO+LjDzFtHFCRJeN4IAR544M\/uCC8YAw888MADDzzwwIuFn2voKX9Rw0iFv8OGpgEe+G943xjd\nK\/1C0muhL5nIyXXhyp2qtzMW+tBLPbtd+2xVqwQ91\/bg+I7xft4SGJTAG23HhVteLMgVwFttR4Vb\nzg\/NPAFLjrrhccsTpC2lZviSXepFtZp5om0VpbpVkYwADzwBHngCvIh8Ag3lAhMN2JymAAAAAElF\nTkSuQmCC","width":30}
%---
%[text:image:5981]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:29a6]
%   data: {"label":"View Example","run":"Section"}
%---
%[text:image:67b7]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARL\noIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx\n2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xe\nDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou\n8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP\n2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCC\nM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+C\nWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTw\nV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHK\nQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBt\nArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyX\ndjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC0\n4TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8\nt8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8\nDxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCC\nZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEF\nJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio\n3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+Ec\nB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZg\nf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVa\ntQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:7dbb]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+S\nvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+\nE+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoq\nKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\n\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzv\nAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0\nDShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoC\nB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1\neqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btH\nJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCO\nriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq\n7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjt\nVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/A\nSgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysr\nFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNx\nk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh\n5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElF\nTkSuQmCC","width":22}
%---
%[text:image:429b]
%   data: {"align":"baseline","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAF4AAABMCAYAAADkzAD+AAABzklEQVR42u3cXXGEMBSG4ZWAhJWA\nBCQgAQcgAQkrIRIqAQlIiAQcUDJDO91OKFBCOCe8F9\/1Js8y+TkJPMZxfJD4AQF44AnwwBPggSfA\nA0+AB\/4tdV1nU4pEk4uEdw2bMkwZE46RCN8njv6VXBr8eJMUkuGLlCZL4IEHHnjggQceeOCBBx74\nUI16Tml+1zT2FJWA31+JfK1srzv3xwAfFn1rUWzQ\/vRLgu92FpYcfgb8sUZUZ9aygT+n7p4Bf03d\nvQD+fw0oDsK3wAN\/q6GmBP6ayfUJfPzlZMdyMv5Tr3r3KgneFcbsDviKkkHYes3HCrhNoUQstSzs\nru61nqpkpR2cgxDggY8OPy8jj15MtfOwlAG\/7YdN4IufVtPy8hJ4z8QZKj3wf6\/Xz7zy3ADv\/8Hm\nZPgO+LjDzFtHFCRJeN4IAR544M\/uCC8YAw888MADDzzwwIuFn2voKX9Rw0iFv8OGpgEe+G943xjd\nK\/1C0muhL5nIyXXhyp2qtzMW+tBLPbtd+2xVqwQ91\/bg+I7xft4SGJTAG23HhVteLMgVwFttR4Vb\nzg\/NPAFLjrrhccsTpC2lZviSXepFtZp5om0VpbpVkYwADzwBHngCvIh8Ag3lAhMN2JymAAAAAElF\nTkSuQmCC","width":30}
%---
%[text:image:4c22]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:755e]
%   data: {"label":"View Example","run":"Section"}
%---
%[text:image:519c]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARL\noIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx\n2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xe\nDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou\n8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP\n2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCC\nM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+C\nWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTw\nV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHK\nQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBt\nArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyX\ndjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC0\n4TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8\nt8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8\nDxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCC\nZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEF\nJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio\n3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+Ec\nB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZg\nf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVa\ntQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:0e13]
%   data: {"align":"bottom","height":24,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAsCAYAAAAXb\/p7AAADlklEQVR42u1YS0hUYRQejR4UvR+S\nvaCyWiS2DIoCKWjVYzG2SsYWQ+a8HRwXFkOgqdGLSoSeqyBaJUGLCKGkNpGtgiyScnpYBpaU5au+\nE+eH03Wu93rvP2OEFw46955z\/u8\/7\/\/3eDQ+4XD4Eui65199AK4d1DEJcBLgfw0wGo2ujkQi1yoq\nKlY5AFgDqnWw5lpaMxaLrbBkDgaDm7HIEKjTCcjxPqFQqABrdYEGsHaRXaESCAyCXpNFMwwuReDw\n\/77xusurQGJna0ysPR2K94CnGdQKesnUyu92J5PJaelk4c51Chzcu9dp0O9nkO3yvd\/vnwqlEbzv\nAf2yoB5sIkwyBt0doJ+0Qbdu2AXyC8UrOVuNQH5Q3IJegfrTfH8ikwC\/A9hjsdaYCQQCG6D4vVj0\nDShB7+HKXMGaQ\/EFADEGrPhJdn1GAhoZvRDKX4jFTvt8vhlWchSD4D0OGiE5AH9eXl4+PxNF+IoC\nB8sccyBfreQB8qJWcAC0CYqHeYE2cqEDNTmQvcc6hlC+CnXWq\/PCtTtdeGGr0HNWFz7aeTcr\/eT1\neqe41PVWJYxd62zkovwXqQ6Cv8vErm9r8MZNEctLVf9Ph4GwecSOjPSQu8V28e6chmRrFPq28btH\nJhhSBKDIBH0B726HEDilAWCtsGCx6MmjMNgaHqBkiygPl3UmHE1OrjOEiqoqsqDHGizYxrqGAXCO\nriL9jJUOoq3lO9UDQItpQGD3PtXZRapFHB51oSchwiWsDWA8Hl8Cpb2svA+WWO4AXJ7Q0Z1IJObq\n7sUBN\/UQLr0hrHfANSCaQihrobiBf+dC+QOxSNk4MrdEyN1VvRy6T+DdVbOp2wpcCyutN8yDahjt\nVZ3A4sS2ALwflYxhaK1n0C22QfL8dkuNRYZBlKxxRLj6gg3XNgj+w8beLOriHcv50gocJ8wsfP\/A\nSgfMDlRs8XzwfGPeThMr2QcpEqFprJmPSoSwSvMYfCcFX6nFlNPEfAGrUuC1GkhxQpspTnTfKysr\nFxl5qqqqZouy0mU81ZmApB6cp2vKlrFVk+Z7TGRuPOsXRZSNfGYmEO\/ofoXmOiKKS3Ga6wPYeRNx\nk9Vo49BONAIL1mUdIBa9bxPgn+zMOkAqIXDdQbp1sKAy6uWeyWd0Cyuk5LDh3pTtez\/NSVJqNwbh\n5kNZB8htkTrP1zHA9dM1nZ07nExmc50ZQGA7M+GxyLden9MA\/OLm\/KKe34xPoKAD7jPkAAAAAElF\nTkSuQmCC","width":22}
%---
%[text:image:8dfe]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:4060]
%   data: {"label":"Show","run":"Section"}
%---
%[text:image:7544]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARL\noIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx\n2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xe\nDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou\n8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP\n2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCC\nM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+C\nWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTw\nV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHK\nQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBt\nArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyX\ndjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC0\n4TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8\nt8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8\nDxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCC\nZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEF\nJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio\n3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+Ec\nB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZg\nf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVa\ntQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:6203]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:411a]
%   data: {"label":"Visualize Results","run":"Section"}
%---
%[text:image:6e0a]
%   data: {"align":"bottom","height":25,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABMCAYAAAAoVToVAAAEVElEQVR42u2c4ZG0IAyGrwRLoARL\noIQtwQ7WEizBEiyBEiiBEiiBDjydifM5jiCQBPU+fuTX3e7iIyRvEuBnnuefamlWIVRoFVqFVqEx\n2\/f7FYtJMFGh\/QPTLPZZbFhML2YXmy\/Mwv8O8Nnmz0ODGdQvZiIAxZqB7xR\/ChrMCk0Iymfrb3xe\nDQ1ghZadW0zBclv9Vxv4Lrlbzgo+G1rGn1dBWx8+MLPWBxpDgBJ\/Zwy8GE3xO+zQYCb4HkAyzuou\n8KKGR0IDJ29KwzoZRx8IGOIx0MDfuJJ+xSNhxotA4SheINWyOA5OldRQMAaXEGW726B5gHVMUAaP\n2Ux50hWH5gG22kQchQ2jruuKQQMfFhrMQATMFRDEkh0aREkX4XDFC4BljTXngWKXy4CIgvZELnCC\nM2zQAsL1zARC721OvgeIssCMG8ihwZKZOWcZwodSWUsNTQd8wlHUNi+FpsmgQXXBm5ocwHXEKl+C\nWJ4L2YcKmvUAaw6+zuXMsl29TRequwWrw2hogaUhDjPC5fgyT7S82yQWmm9pjMfZQlxKutNUNjTw\nV+hok\/n97qLAODMLYJELrb\/44hEJTQcKlmK3fI+JuYbcd2SE1udCMxQhOuH7XWiwAEpcRHT2LOHK\nQc\/M0JodOBWbRUTmvxTWpEL7cEPbgWszxK69S7Nho9pI2F9Yl94E\/ipKvsD\/F89Hc6TGpe8h6iBt\nArq9Ua6oVGi+IKCwXZ0CFVnWYBB6MJZW3EPFrNcw0CSR75oKPrCjSPSzoRE6ezbf42uc7Pa5yZyX\ndjc0TvU+eAKKOZE3rtTyFATQOEs+OtBSbBN86nT8OwYaRUtOcVdcPQ0ZEeEm1C49k1TQLAG0vgC0\n4TBrmoiAZEL1Q5TkeHggmMFfbT6rS2gSydDOAYy4NS+QHGpz9gnuYrzQkQaTRlHuz+AMCAbbCTs8\nt8Im7IZi2ycsIcUsalvE+CwmYZcXIV4QJOsWbNoKjFCSclxV10S\/K6mLkCSVDoYNMBPyReYXIRP8\nDxc4WRLYiT\/TXI0V8n0bEU3qrLZbpK8laawI7sES5qsDsfgWHM1isj4BUe1tIJzVimtbwn6XkGCC\nZkpAOwkAuG0JCQGB9DRcYtqF3a5qU1YOVyT7EDVdWHWZxwVIEmgZ6Y8m0mqopm5G05luU1\/GctEF\nJYch9JmCFFpiNNMFBK7G+NATOUO\/UTlxmWrCCHp2fHsi9pdJ481Vzo4znQn8bodN206AJW955Uio\n3feB10IEgCWXkTgkQf8SYGUPlF0MZHwgsPERRxcvDqiaJyxRzxFx973zkOyFj3OcZaNIeeQoS+Ec\nB\/8bjxyxHKeNI8roZ7qO5PhRyXKOhQdqGOWIfdUVEye+JHQAbcJesLS74GnibADdcW2OjMggttZg\nf3b91+FasAEgmYgNMWx3gZTyM6VO0qkSF6fccWdaTwxQbSeQ\/4ub+nZLTsUWAva3YNXrDeudkBVa\ntQoNb78ox6WFMDJfcAAAAABJRU5ErkJggg==","width":25}
%---
%[text:image:7ee1]
%   data: {"align":"baseline","height":26,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAB4AAAApCAYAAAAiT5m3AAADOElEQVR42r1XSWgUQRSNGndR3Ii7\nV\/EmCCp4DaIe1Oh4EMHBwMjsq47Eg+OOJ0VIICAeFAIeXEADHgyoqChE1ASNhISAxH0jg5gxq+\/F\nX1A009PTM93T8OiuX7\/q1f+\/+tevqqoCTyKRWBmNRo8Cj4GPwF++I5HII7zT8Xh8eZWTTzgcnh6L\nxc5j8kFgHMgCT4G7wBPgl8j\/YBGnfT7f1LJJg8HgQrGQE3diAXVciK5DIsi3o7+devh+4Pf755dM\nmslkpmGih0LaiHa1hf5k6J0T\/TYrfdMHKz8pFjTr1kFWD9ltvJ8Bt\/Dt1d0rYeG4Y7ZJMbAG+A30\n0HLKuHkw2SuxKAe8lQ3Gdjv6llLP4\/FMQfs1MMBQ2SUOyaoPihur0X4BDGEDHVGLYbwhawCG6QG6\nW6yu43jo+uwSt3IyWLlA2vt09+F7CwlDodAaaZ+Q\/j3inZn0GENil\/gd0Ke1rwEjgUBgDqzYIe4l\nBiBbkkqlZov7r2hjXtLldom\/0LVa+x7QK9+NGjHduUvkfcAdbUwb0G+XuNtg8WV6QeLXbCDeKzo9\nQJM2phPosEt8ExijG9nG5NuKJK6VTTeXrofudbvEh2TS49r\/eakQMeQXNV2v9Nfbzc9c8U\/GWv2L\nKkmYEat+r9c7Q+L9nZvOdhLBhOF86c+MWJ5JkLVIX6jUdM1Jbsgk3NU1RRBPHCzQ2crxZR0U3CBC\n8saKGO3NCNNGx85kpk4QPLfaXJr8jGPkKs4FfqesJv9kcP1OvFeXa70Z8Ygmz1KWTCYX4fuDqlAQ\nhnUVIWafQfesXjjgF5zlCrGWSBQuyOm1nuEARqGTqRgxKxejrm1iYL+URKPFEktJrGSDpRJ3aYlG\nYRhFwjK8T+lyle+1yrUsYjMM5ZG9l0tBzk3iYvGfWE6XVWYniyvEci1RgjEpZwP6Itwi7jfppHy3\n1Mz3HSeGNZvw8aOAUs5h0olUqqqPFVIhjlcI34wXsMMuWWhEb76ibwPw1U1ibmCzwm+tdil3HEyf\nhcrdBhetbrW6pHe5RNxiVeTXukTcVEyevupCjA9YEqfT6XlyGXOKuINnQ1GnEy9y6uJeBuFn3qXx\nxyzmnP8Amz0wy7TM4YgAAAAASUVORK5CYII=","width":19}
%---
%[control:button:138a]
%   data: {"label":"Visualize Results","run":"Section"}
%---
