import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

/**
 * Created by matt on 2016-12-21.
 */
public class Day05Test {

    @Test
    public void testDay01_Part1() throws Exception {
        Day05 day5 = new Day05();
        // My tests
        // Sample cases from problem
        assertEquals("18f47a30", day5.password("abc"));
    }
}
