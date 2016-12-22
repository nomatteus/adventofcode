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
        // Sample cases from problem
        assertEquals("18f47a30", day5.password_part1("abc"));
        assertEquals("05ace8e3", day5.password_part2("abc"));
        // Part1 solution - regression test
        assertEquals("c6697b55", day5.password_part1("ffykfhsq"));
        // Part2 solution
        assertEquals("8c35d1ab", day5.password_part2("ffykfhsq"));
    }
}
