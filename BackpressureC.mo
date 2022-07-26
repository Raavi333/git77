within Abusesystem;

model BackpressureC
  Modelica.SIunits.Force Fr;
  parameter Modelica.SIunits.Area A;
  // area of the flaps
  parameter Types.Gasexplosionconstant Kg;
  Modelica.SIunits.Pressure Pred;
  parameter Modelica.SIunits.Volume V;
  Modelica.SIunits.Time Tr;
  //backpressure exertion time
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(visible = true, transformation(origin = {112, 2}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Interfaces.Pressureport_b u annotation(
    Placement(visible = true, transformation(origin = {-94, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-94, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  Tr = Kg * V / (A * Pred * 10000);
  Fr = 119 * A * Pred;
  Tr = y;
  u.P = Pred;
  u.Pdiff=0;
end BackpressureC;
