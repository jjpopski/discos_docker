/*******************************************************************************
 * ALMA - Atacama Large Millimiter Array
 * (c) European Southern Observatory, 2002
 * Copyright by ESO (in the framework of the ALMA collaboration)
 * and Cosylab 2002, All rights reserved
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
 */

package alma.ACS.impl;

import org.omg.CORBA.BooleanHolder;
import org.omg.CORBA.FloatHolder;

import alma.ACS.CBDescIn;
import alma.ACS.Callback;
import alma.ACS.MonitorfloatOperations;

/**
 * Implementation of <code>alma.ACS.Monitorfloat</code>.
 * @author <a href="mailto:matej.sekoranjaATcosylab.com">Matej Sekoranja</a>
 * @author <a href="mailto:cmenayATcsrg.inf.utfsm.cl">Camilo Menay</a>
 * @author <a href="mailto:cmaureirATinf.utfsm.cl">Cristian Maureira</a>
 * @version $id$
 */
public class MonitorfloatImpl
	extends CommonComparableMonitorImpl
	implements MonitorfloatOperations {

	/**
	 * @param property
	 * @param callback
	 * @param descIn
	 * @param startTime
	 */
	public MonitorfloatImpl(
		CommonComparablePropertyImpl property,
		Callback callback,
		CBDescIn descIn,
		long startTime) {
		super(property, callback, descIn, startTime);
	}

	/**
	 * @see alma.ACS.MonitorfloatOperations#get_value_trigger(org.omg.CORBA.FloatHolder, org.omg.CORBA.BooleanHolder)
	 */
	public void get_value_trigger(FloatHolder deltaHolder, BooleanHolder enableHolder) {
		deltaHolder.value = ((Float)getValueTrigger(enableHolder)).floatValue();
	}

	/**
	 * @see alma.ACS.MonitorfloatOperations#set_value_trigger(float, boolean)
	 */
	public void set_value_trigger(float delta, boolean enable) {
		setValueTrigger(new Float(delta), enable);
	}

	/**
	 * @see alma.ACS.MonitorfloatOperations#get_value_percent_trigger(org.omg.CORBA.DoubleHolder, org.omg.CORBA.BooleanHolder)
	 */
	public void get_value_percent_trigger(org.omg.CORBA.DoubleHolder deltaHolder, org.omg.CORBA.BooleanHolder enableHolder) {
	}

	/**
	 * @see alma.ACS.MonitorfloatOperations#set_value_percent_trigger(org.omg.CORBA.DoubleHolder, boolean)
	 */
	public void set_value_percent_trigger(double delta, boolean enable) {
	}
}

