package se.sjv.rules;

import java.math.BigDecimal;

public class DataCarrier {
	
	private BigDecimal value;
	
	public DataCarrier(final BigDecimal d) {
		this.value = d;
	}
	
	public BigDecimal getValue() {
		return value;
	}
	
	public void setValue(BigDecimal d) {
		this.value = d;
	}
	
}