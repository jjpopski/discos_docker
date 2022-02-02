package org.jacorb.test.notification;

/*
 *        JacORB - a free Java ORB
 *
 *   Copyright (C) 1999-2014 Gerald Brose / The JacORB Team.
 *
 *   This library is free software; you can redistribute it and/or
 *   modify it under the terms of the GNU Library General Public
 *   License as published by the Free Software Foundation; either
 *   version 2 of the License, or (at your option) any later version.
 *
 *   This library is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *   Library General Public License for more details.
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this library; if not, write to the Free
 *   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import org.jacorb.notification.util.CollectionsWrapper;
import org.junit.Test;

/**
 * @author Alphonse Bendt
 */

public class CollectionsWrapperTest
{
    @Test
    public void testTime() throws Exception
    {
        List[] list = new List[1000];

        for (int x = 0; x < list.length; ++x)
        {
            list[x] = Collections.singletonList("testling");
        }

        Method method = Collections.class.getMethod("singletonList", new Class[] { Object.class });

        for (int x = 0; x < list.length; ++x)
        {
            list[x] = (List) method.invoke(null, new Object[] { "testling" });
        }
    }

    @Test
    public void testCollectionsWrapper() throws Exception
    {
        String o = "testling";

        List list = CollectionsWrapper.singletonList(o);

        assertTrue(list.size() == 1);

        assertEquals(o, list.get(0));

        Iterator i = list.iterator();

        while (i.hasNext())
        {
            assertEquals(o, i.next());
        }
    }

    @Test
    public void testModificationsFail() throws Exception
    {
        String data = "testling";

        List list = CollectionsWrapper.singletonList(data);
        
        try
        {
            list.add("another");
            fail();
        } catch (UnsupportedOperationException e)
        {
            // expected
        }
        
        try {
            list.remove(0);
            fail();
        } catch (UnsupportedOperationException e)
        {
            // expected
        }
        
        assertEquals(1, list.size());
        assertEquals(data, list.get(0));
    }

}
