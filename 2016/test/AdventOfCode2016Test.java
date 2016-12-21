import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by matt on 2016-12-21.
 */
public class AdventOfCode2016Test {
    @Test
    public void testDay01_Part1() {
        Day01 day1 = new Day01();
        // My tests
        assertEquals(0, day1.calculate("L2, L2, L2, L2"));
        assertEquals(0, day1.calculate("R2, R2, R2, R2"));
        // Sample cases from problem
        assertEquals(5,day1.calculate("R2, L3"));
        assertEquals(2,day1.calculate("R2, R2, R2"));
        assertEquals(12,day1.calculate("R5, L5, R5, R3"));
    }

    @Test
    public void testDay01_Part2() {
        Day01 day1 = new Day01();
        // My tests
        assertEquals(0, day1.distanceToFirstLocationVisitedTwice("R1, R1, R1, R1"));
        // Sample cases from problem
        assertEquals(4, day1.distanceToFirstLocationVisitedTwice("R8, R4, R4, R8"));
    }
}
