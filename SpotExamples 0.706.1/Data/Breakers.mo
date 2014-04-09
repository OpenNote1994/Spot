within SpotExamples.Data;
package Breakers "Breaker example data"
  extends Spot.Base.Icons.SpecialLibrary;


  record BreakerArc "Breaker, 3-phase, example"
    extends Spot.Base.Icons.Record;

    parameter SI.Distance D= 50e-3 "contact distance open";
    parameter SI.Time t_opening= 30e-3 "opening duration";
    parameter SI.ElectricFieldStrength Earc= 50e3 "electric field arc";
    parameter Real R0= 1 "small signal resistance arc";
    annotation (defaultComponentName="breakerExpl",
      Documentation(
              info="<html>
</html>
"));
  end BreakerArc;
  annotation (preferredView="info",
Documentation(info="<html>
</html>"));
end Breakers;
