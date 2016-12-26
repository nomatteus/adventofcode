import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Created by matt on 2016-12-26.
 */
public class Day09 {

    public String decompressedString(String input) {
        return "";
    }

    public int decompressedLength(String input) {
        return decompressedString(input).length();
    }

    public static void main(String[] args) throws Exception {
        String input = new String(Files.readAllBytes(Paths.get("src/inputs/day09")));
    }
}
