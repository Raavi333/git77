within Abusesystem;

package Tuv
  function Pmax
    input Modelica.SIunits.Temperature T;
    input Modelica.SIunits.Pressure P;
    output Modelica.SIunits.Pressure PMAX;
    parameter Modelica.SIunits.Temperature T1;
    parameter Modelica.SIunits.Pressure P1;
  algorithm
    PMAX := P * (1 - T1 / T) + PMAX(T = T1, P = P1) * T1 * P / T * P1;
  end Pmax;

  model pressuremax
    Modelica.SIunits.Pressure Pm, P;
    parameter Modelica.SIunits.Temperature Tin = 300;
    //Modelica.SIunits.Temperature T= Heatrelease.T2;
    Real rate = Tempraturerate(T2 = 1100, T1 = 300);
  initial equation
    P = 1;
  equation
    der(P) = 0.001;
    Pm = rate * P;
// der(T) = 1;
// der(P) = 1;
  end pressuremax;

  model Temp
  Modelica.SIunits.Heat Q;
    Modelica.SIunits.Temperature T;
    //  parameter Modelica.SIunits.Temperature T1=30;
    //parameter Modelica.SIunits.Mass m=1.5;
    // parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure Cop= 15;
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a annotation(
      Placement(visible = true, transformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Interfaces.Tempport_b tempport_b annotation(
      Placement(visible = true, transformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    port_a.Q_flow = -Q;
    Q = (H2gas.H2percentage * H2gas.Vb * H2gas.d + H2gas.airpercentage * H2gas.Vb * 1.225) * 15 * (T - 300);
    tempport_b.T = T;
  port_a.T=0;
  end Temp;

  record H2gas
  parameter Modelica.SIunits.Volume Vb = 1;
    // volume of test box
    parameter Modelica.SIunits.Density d = 0.08;
    // density of gas
    parameter Modelica.SIunits.SpecificHeatCapacityAtConstantPressure Cp = 15;
    // specific heat of gas
    parameter Real H2percentage = 0.30;
    parameter Real airpercentage = 1 - H2gas.H2percentage;
    parameter Real q = 140000;
  // combustion heat in kj/kg
  end H2gas;

  model tuvtest
    Temp temp annotation(
      Placement(visible = true, transformation(origin = {-2, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Heatrelease heatrelease annotation(
      Placement(visible = true, transformation(origin = {-76, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Abusesystem.Tuv.pressurerise pressurerise(T1(displayUnit = "degC")) annotation(
      Placement(visible = true, transformation(origin = {74, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(temp.tempport_b, pressurerise.tempport_a);
    connect(heatrelease.port_b, temp.port_a) annotation(
      Line(points = {{-66, 70}, {-12, 70}}, color = {191, 0, 0}));
    connect(temp.tempport_b, pressurerise.tempport_a) annotation(
      Line(points = {{8, 70}, {64, 70}}));
  end tuvtest;

  model Ratemodel
    Abusesystem.Tuv.rate rate annotation(
      Placement(visible = true, transformation(origin = {-10, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Real rr;
    Modelica.SIunits.Temperature T;
    Modelica.SIunits.Pressure Pex;
    Interfaces.Tempport_b tempport_b annotation(
      Placement(visible = true, transformation(origin = {90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    rate.tempport_b.T = T;
    rr = Tempraturerate(T);
    tempport_b.T = -rr;
    
  end Ratemodel;

  model Temprise
  extends Ratemodel;
    parameter Modelica.SIunits.Pressure P1 = 1.2;
    Modelica.SIunits.Pressure pmax;
  equation
//pmax= P1*rr;
    der(pmax) = 8.314 * 0.8 * rr;
  end Temprise;

  model pressurerise
    parameter Modelica.SIunits.Pressure P1 = 1;
    parameter Modelica.SIunits.Temperature T1 = 298, T2;
    Interfaces.Tempport_a tempport_a annotation(
      Placement(visible = true, transformation(origin = {-98, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.SIunits.Pressure P2;
  equation
    T2 = tempport_a.T;
    P2 = P1 * T2 / T1;
  end pressurerise;
end Tuv;
