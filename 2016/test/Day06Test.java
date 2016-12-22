import org.junit.Test;

import static junit.framework.Assert.assertEquals;

/**
 * Created by matt on 2016-12-21.
 */

public class Day06Test {

    @Test
    public void test_Day06() {
        Day06 day6 = new Day06();
        assertEquals("easter", day6.getMessage_part1("eedadn\n" +
                "drvtee\n" +
                "eandsr\n" +
                "raavrd\n" +
                "atevrs\n" +
                "tsrnev\n" +
                "sdttsa\n" +
                "rasrtv\n" +
                "nssdts\n" +
                "ntnada\n" +
                "svetve\n" +
                "tesnvt\n" +
                "vntsnd\n" +
                "vrdear\n" +
                "dvrsen\n" +
                "enarar"));
        assertEquals("advent", day6.getMessage_part2("eedadn\n" +
                "drvtee\n" +
                "eandsr\n" +
                "raavrd\n" +
                "atevrs\n" +
                "tsrnev\n" +
                "sdttsa\n" +
                "rasrtv\n" +
                "nssdts\n" +
                "ntnada\n" +
                "svetve\n" +
                "tesnvt\n" +
                "vntsnd\n" +
                "vrdear\n" +
                "dvrsen\n" +
                "enarar"));
    }

}
