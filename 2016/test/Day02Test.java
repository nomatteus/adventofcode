import org.junit.Test;

import java.util.Scanner;

import static org.junit.Assert.assertEquals;

/**
 * Created by matt on 2016-12-21.
 */
public class Day02Test {

    @Test
    public void testDay01_Part1() {
        Day02 day2 = new Day02();
        // My tests
        // Sample cases from problem
        assertEquals("1985", day2.calculate(new Scanner("ULL\nRRDDD\nLURDL\nUUUUD")));
    }
}
