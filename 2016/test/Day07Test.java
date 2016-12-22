import org.junit.Test;

import static junit.framework.Assert.assertEquals;

/**
 * Created by matt on 2016-12-22.
 */

public class Day07Test {

    @Test
    public void test_Day07() {
        Day07 day7 = new Day07();
        // part 1
        assertEquals(true, day7.supportsTLS("abba[mnop]qrst"));
        assertEquals(false, day7.supportsTLS("abcd[bddb]xyyx"));
        assertEquals(false, day7.supportsTLS("aaaa[qwer]tyui"));
        assertEquals(true, day7.supportsTLS("ioxxoj[asdfgh]zxcvbn"));
        // part 2
        assertEquals(true, day7.supportsSSL("aba[bab]xyz"));
        assertEquals(false, day7.supportsSSL("xyx[xyx]xyx"));
        assertEquals(true, day7.supportsSSL("aaa[kek]eke"));
        assertEquals(true, day7.supportsSSL("zazbz[bzb]cdb"));
    }

}
