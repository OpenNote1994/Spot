within Spot.ACabc;
package Sensors "Sensors and meters 3-phase"
  extends Base.Icons.Library;

  model VnormSensor "Voltage-norm sensor, 3-phase abc"
    extends Partials.Sensor1Base(final signalTrsf=0);

    parameter Integer n_eval(
      min=2,
      max=3) = 2 "abc-o  or abc norm" annotation(choices(
      choice=2 "2: abc - zero-component",
      choice=3 "3: abc"));
    Modelica.Blocks.Interfaces.RealOutput v "voltage norm abc, phase-to-ground"
      annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
    if n_eval == 3 then
      v = sqrt(term.v*term.v);
    else
      v = sqrt(term.v*term.v - sum(term.v)*sum(term.v)/3);
    end if;
  annotation (defaultComponentName = "Vsensor1",
    Documentation(
            info="<html>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Rectangle(
            extent={{-20,24},{20,20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}));
  end VnormSensor;

  model InormSensor "Current-norm sensor, 3-phase abc"
    extends Partials.Sensor2Base(final signalTrsf=0);

    parameter Integer n_eval(
      min=2,
      max=3) = 2 "abc-o  or abc norm" annotation(choices(
      choice=2 "2: abc - zero-component",
      choice=3 "3: abc"));
    Modelica.Blocks.Interfaces.RealOutput i
      "current norm abc, term_p to term_n" annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
    if n_eval == 3 then
      i = sqrt(term_p.i*term_p.i);
    else
      i = sqrt(term_p.i*term_p.i - sum(term_p.i)*sum(term_p.i)/3);
    end if;
  annotation (defaultComponentName = "Isensor1",
    Documentation(
            info="<html>
</html>
"));
  end InormSensor;

  model Vsensor "Voltage sensor, 3-phase abc"
    extends Partials.Sensor1Base;

    Modelica.Blocks.Interfaces.RealOutput[3] v "voltage abc, phase-to-ground"
      annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
    if signalTrsf == 0 then
      v = term.v; // actual
    elseif signalTrsf == 1 then
      v = park(term.theta[1])*term.v; // dqo
    elseif signalTrsf == 2 then
      v = transpose(park(term.theta[2]))*term.v; // alpha-beta_o
    elseif signalTrsf == 3 then
      v = rot_abc(term.theta[2])*term.v; // abc
    end if;
  annotation (defaultComponentName = "Vsensor1",
    Documentation(
            info="<html>
<p>The parameter 'signalTrsf' allows the choice of different reference systems for the output signal<br>
<pre>
  signalTrsf=0     voltage in actual ref frame
  signalTrsf=1     voltage in dqo synchronous frame
  signalTrsf=2     voltage in alpha_beta_o frame
  signalTrsf=3     voltage in abc inertial frame
</pre>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-20,24},{20,20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Line(points={{-20,60},{20,80}}, color={135,135,135}),
          Line(points={{-20,50},{20,70}}, color={135,135,135}),
          Line(points={{-20,40},{20,60}}, color={135,135,135})}));
  end Vsensor;

  model Isensor "Current sensor, 3-phase abc"
    extends Partials.Sensor2Base;

    Modelica.Blocks.Interfaces.RealOutput[3] i "current abc, term_p to term_n"
      annotation (Placement(transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));

  equation
     if signalTrsf == 0 then
      i = term_p.i; // actual
    elseif signalTrsf == 1 then
      i = park(term_p.theta[1])*term_p.i; // dqo
    elseif signalTrsf == 2 then
      i = transpose(park(term_p.theta[2]))*term_p.i; // alpha-beta_o
    elseif signalTrsf == 3 then
      i = rot_abc(term_p.theta[2])*term_p.i; // abc
    end if;
  annotation (defaultComponentName = "Isensor1",
    Documentation(
            info="<html>
<p>The parameter 'signalTrsf' allows the choice of different reference systems for the output signal<br>
<pre>
  signalTrsf=0     current in actual ref frame
  signalTrsf=1     current in dqo synchronous frame
  signalTrsf=2     current in alpha_beta_o frame
  signalTrsf=3     current in abc inertial frame
</pre>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-20,60},{20,80}}, color={135,135,135}),
          Line(points={{-20,50},{20,70}}, color={135,135,135}),
          Line(points={{-20,40},{20,60}}, color={135,135,135})}));
  end Isensor;

  model Psensor "Power sensor, 3-phase abc"
    extends Partials.Sensor2Base(final signalTrsf=0);

    Modelica.Blocks.Interfaces.RealOutput[3] p
      "{active, reactive, DC} power, term_p to term_n" annotation (Placement(
          transformation(
          origin={0,100},
          extent={{-10,-10},{10,10}},
          rotation=90)));
  protected
    SIpu.Power pDC;

  equation
    pDC = sum(term_p.v)*sum(term_p.i)/3;
    p = {term_p.v*term_p.i - pDC, -j_abc(term_p.v)*term_p.i, pDC};
  annotation (defaultComponentName = "Psensor1",
    Documentation(
            info="<html>
<p><i>Comment on the sign-definition of reactive power see</i> ACabc.Sensors.</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-20,20},{20,-20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid), Line(
            points={{0,0},{20,0}},
            color={0,130,175},
            thickness=0.5)}));
  end Psensor;

  model Vmeter "Voltage meter, 3-phase abc"
    extends Partials.Meter1Base(final S_nom=1);

    output SIpu.Voltage[3] v(each stateSelect=StateSelect.never);
    output SIpu.Voltage[3] vpp(each stateSelect=StateSelect.never);

    output SIpu.Voltage[3] v_abc(each stateSelect=StateSelect.never)=Rot*v if abc;
    output SIpu.Voltage[3] vpp_abc(each stateSelect=StateSelect.never)=
      {v_abc[2],v_abc[3],v_abc[1]} - {v_abc[3],v_abc[1],v_abc[2]} if abc;

    output SIpu.Voltage v_norm(stateSelect=StateSelect.never)=sqrt(v*v) if phasor;
    output SI.Angle alpha_v(stateSelect=StateSelect.never)=atan2(Park[2,:]*v, Park[1,:]*v) if phasor;
  protected
    final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);

  equation
    v = term.v/V_base;
    vpp={v[2],v[3],v[1]} - {v[3],v[1],v[2]};
    annotation (defaultComponentName = "Vmeter1",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-20,24},{20,20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Line(points={{-15,50},{15,64}}, color={135,135,135}),
          Line(points={{-15,40},{15,54}}, color={135,135,135}),
          Line(points={{-15,30},{15,44}}, color={135,135,135})}),
      Documentation(
              info="<html>
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals in alternative representations, both in SI-units or in 'pu'.<br>
As they use time-dependent coordinate transforms, use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables in the chosen reference system:</p>
<pre>
  v         voltage phase-to-ground
  vpp       voltage phase-to-phase
</pre>
<p>Optional output variables:</p>
<pre>
  v_abc     voltage phase-to-ground, abc-inertial system
  vpp_abc   voltage phase-to-phase,  abc-inertial system
  v_norm    norm(v)
  alpha_v   phase(v)
</pre>
</html>
"));
  end Vmeter;

  model Imeter "Current meter, 3-phase abc"
    extends Partials.Meter2Base;

    output SIpu.Current[3] i(each stateSelect=StateSelect.never);

    output SIpu.Current[3] i_abc(each stateSelect=StateSelect.never)=Rot*i if abc;

    output SIpu.Current i_norm(stateSelect=StateSelect.never)=sqrt(i*i) if phasor;
    output SI.Angle alpha_i(stateSelect=StateSelect.never)=atan2(Park[2,:]*i, Park[1,:]*i) if phasor;
  protected
    final parameter SI.Current I_base=Base.Precalculation.baseI(units, V_nom, S_nom);

  equation
    i = term_p.i/I_base;
    annotation (defaultComponentName = "Imeter1",
      Documentation(
              info="<html>
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals in alternative representations, both in SI-units or in 'pu'.<br>
As they use time-dependent coordinate transforms, use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables in the chosen reference system:</p>
<pre>  i          current term_p to term_n</pre>
<p>Optional output variables:</p>
<pre>
  i_abc      current term_p to term_n, abc-inertial system
  i_norm     norm(i)
  alpha_i    phase(i)
</pre>
</html>
"),   Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{-15,50},{15,64}}, color={135,135,135}),
          Line(points={{-15,40},{15,54}}, color={135,135,135}),
          Line(points={{-15,30},{15,44}}, color={135,135,135})}));
  end Imeter;

  model Pmeter "Power meter, 3-phase abc"

    parameter Boolean av=false "time average power?"   annotation(evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
                                                    annotation(Evaluate=true, Dialog(group="Options",enable=av));
    extends Partials.Meter2Base(final V_nom=1, final abc=false, final phasor=false);

    output SIpu.Power[3] p(each stateSelect=StateSelect.never);
    output SIpu.Power[3] p_av=pav if av;
  protected
    outer System system;
    final parameter SI.ApparentPower S_base=Base.Precalculation.baseS(units, S_nom);
    SIpu.Power[3] pav;
    SIpu.Power pDC;

  initial equation
    if av then
      pav = p;
    end if;

  equation
    pDC = sum(term_p.v)*sum(term_p.i)/3;
    p = {term_p.v*term_p.i - pDC, -j_abc(term_p.v)*term_p.i, pDC}/S_base;
    if av then
      der(pav) = (p - pav)/tcst;
    else
      pav = zeros(3);
    end if;
    annotation (defaultComponentName = "Pmeter1",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Ellipse(
            extent={{-20,20},{20,-20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,0},{20,0}},
            color={0,130,175},
            thickness=0.5),
          Ellipse(extent={{-70,70},{70,-70}}, lineColor={135,135,135})}),
      Documentation(
              info="<html>
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals in alternative representations, both in SI-units or in 'pu'.<br>
Use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables:</p>
<pre>  p         {AC active, AC reactive, DC} power term_p to term_n</pre>
<p>Optional output variables:</p>
<pre>  p_av       power term_p to term_n, time tau average of p</pre>
<p><i>Comment on the sign-definition of reactive power see</i> ACdqo.Sensors.</p>
</html>
"));
  end Pmeter;

  model PVImeter "Power-voltage-current meter, 3-phase abc"
    extends Partials.Meter2Base;

    parameter Boolean av=false "time average power?"   annotation(evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
                                                    annotation(Evaluate=true, Dialog(group="Options",enable=av));

    output SIpu.Power[3] p(each stateSelect=StateSelect.never);
    output SIpu.Power[3] p_av=pav if av;
    output SIpu.Voltage[3] v(each stateSelect=StateSelect.never);
    output SIpu.Voltage[3] vpp(each stateSelect=StateSelect.never);
    output SIpu.Current[3] i(each stateSelect=StateSelect.never);

    output SIpu.Voltage[3] v_abc(each stateSelect=StateSelect.never)=Rot*v if abc;
    output SIpu.Voltage[3] vpp_abc(each stateSelect=StateSelect.never)=
      {v_abc[2],v_abc[3],v_abc[1]} - {v_abc[3],v_abc[1],v_abc[2]} if abc;
    output SIpu.Current[3] i_abc(each stateSelect=StateSelect.never)=Rot*i if abc;

    output SIpu.Voltage v_norm(stateSelect=StateSelect.never)=sqrt(v*v) if phasor;
    output SI.Angle alpha_v(stateSelect=StateSelect.never)=atan2(Park[2,:]*v, Park[1,:]*v) if phasor;
    output SIpu.Current i_norm(stateSelect=StateSelect.never)=sqrt(i*i) if phasor;
    output SI.Angle alpha_i(stateSelect=StateSelect.never)=atan2(Park[2,:]*i, Park[1,:]*i) if phasor;
    output Real cos_phi(stateSelect=StateSelect.never)=cos(alpha_v - alpha_i) if phasor;
  protected
    outer System system;
    final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
    final parameter SI.Current I_base=Base.Precalculation.baseI(units, V_nom, S_nom);
    SIpu.Power[3] pav;
    SIpu.Power pDC;

  initial equation
    if av then
      pav = p;
    end if;

  equation
    v = term_p.v/V_base;
    vpp = {v[2],v[3],v[1]} - {v[3],v[1],v[2]};
    i = term_p.i/I_base;
    pDC = sum(v)*sum(i)/3;
    p = {v*i - pDC, -j_abc(v)*i, pDC};
    if av then
      der(pav) = (p - pav)/tcst;
    else
      pav = zeros(3);
    end if;
    annotation (defaultComponentName = "PVImeter1",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-20,24},{20,20}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-8,8},{8,-8}},
            lineColor={135,135,135},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Line(
            points={{0,0},{20,0}},
            color={0,130,175},
            thickness=0.5),
          Line(points={{-15,50},{15,64}}, color={135,135,135}),
          Line(points={{-15,40},{15,54}}, color={135,135,135}),
          Line(points={{-15,30},{15,44}}, color={135,135,135})}),
      Documentation(
              info="<html>
<p>'Meters' are intended as diagnostic instruments. They allow displaying signals in alternative representations, both in SI-units or in 'pu'.<br>
As they use time-dependent coordinate transforms, use them only when and where needed. Otherwise use 'Sensors'.</p>
<p>Output variables in the chosen reference system:</p>
<pre>
  p         {AC active, AC reactive, DC} power term_p to term_n
  v          voltage phase-to-ground dqo
  vpp        voltage phase-to-phase dq
  i          current dqo, term_p to term_n
</pre>
<p>Optional output variables:</p>
<pre>
  p_av       power term_p to term_n, time average of p
  v_abc      voltage phase-to-ground,  abc-inertial system
  vpp_abc    voltage phase-to-phase,   abc-inertial system
  i_abc      current term_p to term_n, abc-inertial system
  v_norm     norm(v)
  i_norm     norm(i)
  alpha_v    phase(v)
  alpha_i    phase(i)
  cos_phi    cos(alpha_v - alpha_i)
</pre>
<p><i>Comment on the sign-definition of reactive power see</i> ACdqo.Sensors.</p>
</html>
"));
  end PVImeter;

  model Efficiency "Power sensor, 3-phase dqo"
    extends Partials.Sensor2Base(final signalTrsf=0);

    Base.Interfaces.ThermalV_p heat(m=m) "vector heat port"
      annotation (Placement(transformation(
          origin={0,100},
          extent={{10,-10},{-10,10}},
          rotation=90)));
    parameter Boolean dir_in=true "direction" annotation(evaluate=true, choices(
      choice=true "points into the component",
      choice=false "point out of the component"));
    parameter Integer m(final min=1)=1 "dimension of heat port";
    parameter Boolean av=false "time average efficiency" annotation(evaluate=true,Dialog(group="Options"));
    parameter SI.Time tcst(min=1e-9)=1 "average time-constant"
      annotation(Evaluate=true, Dialog(group="Options",enable=av));
    parameter SI.Temperature T_amb=300 "ambient temperature";
    output Real eta "efficiency";
  protected
    SI.Power p "total el power, term_p to term_n";
    SI.HeatFlowRate q "total heat flow 'in'";
    SI.Power pav;
    SI.HeatFlowRate qav;

  initial equation
    if av then
      pav = p;
      qav = q;
    end if;

  equation
    heat.port.T = fill(T_amb, heat.m);
    p = term_p.v*term_p.i;
    q = sum(heat.port.Q_flow);

    if av then
      der(pav) = (p - pav)/tcst;
      der(qav) = (q - qav)/tcst;
    else
      pav = p;
      qav = q;
    end if;

    if qav < abs(pav) then
      if dir_in then
        eta = if pav > 0 then 100*(pav - qav)/pav else -100*pav/(pav - qav);
      else
        eta = if pav > 0 then 100*pav/(pav + qav) else -100*(pav + qav)/pav;
      end if;
    else
      eta = 0;
    end if;
    annotation (
      defaultComponentName="efficiency",
  Documentation(
          info="<html>
<p>Measures the electric power <tt>p</tt> flowing from 'term_p' to 'term_n' and the total heat inflow <tt>q</tt> at term 'heat'. The efficiency eta in % is then defined by
<pre>
  eta = 100*(p - q)/p     if arrow points into the measured component and q &lt  abs(p)
  eta = 100*p/(p + q)     if arrow points out of the measured component and q &lt  abs(p)
  eta = 0                 else
</pre>
Positive values of eta indicate powerflow in direction of arrow,
negative values of eta indicate powerflow against direction of arrow.</p>
<p>Note: Take care about the above definitions if approximations are used in measured components.<br>
In problematic cases use power sensors electrical and mechanical.</p>
</html>
"),
  Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Ellipse(
            extent={{-20,20},{20,-20}},
            lineColor={176,0,0},
            fillColor={176,0,0},
            fillPattern=FillPattern.Solid), Line(
            points={{0,0},{20,0}},
            color={0,130,175},
            thickness=0.5)}));
  end Efficiency;

  model Phasor "Visualiser of voltage and current phasor, 3-phase abc"
    extends Partials.PhasorBase;

    Base.Types.Color color_p;
    Base.Types.Color color_n;
    Base.Visualise.Bar activePower(color={0,127,127}, x=x_norm*abs(p[1]))
    annotation (layer="icon", Placement(transformation(extent={{-104,-100},{-94,
              100}}, rotation=0)));
    Base.Visualise.Bar reactivePower(color={127,0,127}, x=x_norm*abs(p[2]))
    annotation (layer="icon", Placement(transformation(extent={{94,-100},{104,
              100}}, rotation=0)));
    Base.Visualise.DoubleNeedle voltage_current(
      color1={255,0,0},
      color2={0,0,255},
      x1=r_norm*v_dq[1],
      y1=r_norm*v_dq[2],
      x2=r_norm*i_dq[1],
      y2=r_norm*i_dq[2])
    annotation (layer="icon", Placement(transformation(extent={{-100,-100},{100,
              100}}, rotation=0)));

  equation
    color_p = if p[1]>0 then {0,127,127} else {215,215,215};
    color_n = if p[1]<0 then {0,127,127} else {215,215,215};
  annotation (
    defaultComponentName="phasor",
      Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Line(points={{4,100},{84,100},{54,88}}, color={128,128,128}),
          Line(points={{-4,100},{-84,100},{-54,88}}, color={128,128,128}),
          Text(
            extent={{-100,-90},{100,-130}},
            lineColor={0,0,0},
            textString=
             "%name")}),
      Documentation(
        info="<html>
<p>Phase representation of voltage and current in 3-phase networks:</p>
<pre>
  red needle      voltage
  blue needle     current
</pre>
<p>(The black circle indicates 1 pu).</p>
<p>Additional bars for power flow:</p>
<pre>
  green left bar        active power
  violet right bar      reactive power
  green arrow           direction of active power flow
</pre>
<p>(The black marks indicate 1 pu).</p>
<p><i>Select 'Diagram' in the Simulation layer, when simulating with this component.</i></p>
</html>
"));
  end Phasor;

  package Partials "Partial models"
    extends Base.Icons.Partials;

    partial model Sensor1Base "Sensor 1 terminal base, 3-phase abc"
      extends Ports.Port_p;

      parameter Integer signalTrsf=0 "signal in which reference frame?"
       annotation(Evaluate=true,Dialog(group="Options"), choices(
         choice=0 "0: actual ref frame",
         choice=1 "1: dqo synchronous",
         choice=2 "2: alpha_beta_o",
         choice=3 "3: abc inertial"));
    protected
      function rot_abc = Base.Transforms.rotation_abc;
      function park = Base.Transforms.park;

    equation
      term.i = zeros(3);
    annotation (
      Documentation(
            info="<html>
</html>"),
      Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Ellipse(
              extent={{-70,70},{70,-70}},
              lineColor={255,255,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-90,0},{40,0}},
              color={0,130,175},
              thickness=0.5),
            Line(points={{0,20},{0,90}}, color={135,135,135})}));
    end Sensor1Base;

    partial model Sensor2Base "Sensor 2 terminal base, 3-phase abc"
      extends Ports.Port_pn;

      parameter Integer signalTrsf=0 "signal in which reference frame?"
       annotation(Evaluate=true,Dialog(group="Options"), choices(
         choice=0 "0: actual ref frame",
         choice=1 "1: dqo synchronous",
         choice=2 "2: alpha_beta_o",
         choice=3 "3: abc inertial"));
    protected
      function rot_abc = Base.Transforms.rotation_abc;
      function park = Base.Transforms.park;

    equation
      term_p.v = term_n.v;
    annotation (
      Documentation(
            info="<html>
</html>"),
      Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Ellipse(
              extent={{-70,70},{70,-70}},
              lineColor={255,255,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{0,20},{0,90}}, color={135,135,135}),
            Line(
              points={{-90,0},{-20,0}},
              color={0,130,175},
              thickness=0.5),
            Line(
              points={{0,0},{90,0}},
              color={0,130,175},
              thickness=0.5),
            Line(
              points={{30,20},{70,0},{30,-20}},
              color={0,130,175},
              thickness=0.5),
            Ellipse(extent={{-20,20},{20,-20}}, lineColor={135,135,135})}));
    end Sensor2Base;

    partial model Meter1Base "Meter 1 terminal base, 3-phase abc"
      extends Sensor1Base(final signalTrsf=0);

      parameter Boolean abc=false "abc inertial"
        annotation(evaluate=true,Dialog(group="Options"));
      parameter Boolean phasor=false "phasor"  annotation(evaluate=true,Dialog(group="Options"));
      extends Base.Units.Nominal;
    protected
      Real[3,3] Rot = rot_abc(term.theta[2]) if abc;
      Real[3,3] Park = park(term.theta[1]) if phasor;
      function atan2 = Modelica.Math.atan2;
      annotation (
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Ellipse(extent={{-70,70},{70,-70}},
                lineColor={135,135,135})}));
    end Meter1Base;

    partial model Meter2Base "Meter 2 terminal base, 3-phase abc"
      extends Sensor2Base(final signalTrsf=0);

      parameter Boolean abc=false "abc inertial"
        annotation(evaluate=true,Dialog(group="Options"));
      parameter Boolean phasor=false "phasor"  annotation(evaluate=true,Dialog(group="Options"));
      extends Base.Units.Nominal;
    protected
      Real[3,3] Rot = rot_abc(term_p.theta[2]) if abc;
      Real[3,3] Park = park(term_p.theta[1]) if phasor;
      function atan2 = Modelica.Math.atan2;
      annotation (
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Ellipse(extent={{-70,70},{70,-70}},
                lineColor={135,135,135})}));
    end Meter2Base;

    partial model PhasorBase "Phasor base, 3-phase abc"
      extends Ports.Port_pn;
      extends Base.Units.Nominal(final units="pu");
      outer System system;

      Real[2] v_dq;
      Real[2] i_dq;
      Real[2] p;
    protected
      constant Real r_norm(unit="pu")=0.8 "norm radius phasor";
      constant Real x_norm(unit="pu")=0.8 "norm amplitude power";
      final parameter SI.Voltage V_base=Base.Precalculation.baseV(units, V_nom);
      final parameter SI.Current I_base=Base.Precalculation.baseI(units, V_nom, S_nom);
      Real[3,3] Park=Base.Transforms.park(term_p.theta[1]);

    equation
      term_p.v = term_n.v;
      v_dq = Park[1:2,:]*term_p.v/V_base;
      i_dq = Park[1:2,:]*term_p.i/I_base;
      p = {v_dq*i_dq, -{-v_dq[2],v_dq[1]}*i_dq};
      annotation (
        Documentation(
        info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={215,215,215},
              fillColor={215,215,215},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-90,90},{90,-90}},
              lineColor={0,0,255},
              pattern=LinePattern.None,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-80,80},{80,-80}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-2,2},{2,-2}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-90,0},{90,0}},
              color={135,135,135},
              pattern=LinePattern.Dot),
            Line(
              points={{-64,-64},{64,64}},
              color={135,135,135},
              pattern=LinePattern.Dot),
            Line(
              points={{0,-90},{0,90}},
              color={135,135,135},
              pattern=LinePattern.Dot),
            Line(
              points={{-64,64},{64,-64}},
              color={135,135,135},
              pattern=LinePattern.Dot),
            Line(
              points={{-94,60},{-84,60}},
              color={0,0,0},
              thickness=0.5),
            Line(
              points={{84,60},{94,60}},
              color={0,0,0},
              thickness=0.5)}));
    end PhasorBase;
  end Partials;
  annotation (preferredView="info",
Documentation(info="<html>
<p>Sensors output terminal signals (voltage, current, power) in a defined reference system chosen by the user.</p>
<p>Meters allow choosing base-units for output variables.</p>
<p><i>Comment on the sign-definition of reactive power:</i></p>
<p>From a mathematical point of view, it would be desirable to define power in the following way:
<pre>
  p_active = v*i
  p_reactive = (J*v)*i
</pre>
<p>with</p>
<pre>  J = [0,-1,1; 1,0,-1; -1,1,0]/sqrt(3)</pre>
<p>the rotation of pi/2 in the positive sense.</p>
<p>This definition keeps all coordinate systems positively oriented.
The power-vector then can be interpreted as current-vector, normalised by voltage and transformed into a positively oriented coordinate system, whose first axis is given by the voltage vector <tt>v</tt>, and second axis by <tt>J*v</tt>.</p>
<p>From a practical point of view it is more convenient to use the inverse sign for reactive power, in order to obtain positive reactive power in the standard-situation of power-transfer
across an inductive line.
We adapt the sign-definition to this practical convention:</p>
<pre>  p_reactive = -(J*v)*i</pre>
</html>
"));
end Sensors;
