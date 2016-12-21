import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-21.
 */
public class Day03 {

    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(Paths.get("src/inputs/day03"));
        int numCorrectTriangles = 0;
        while (scanner.hasNextLine()) {
            int side1 = scanner.nextInt();
            int side2 = scanner.nextInt();
            int side3 = scanner.nextInt();
            if ((side1 + side2) > side3 && (side1 + side3) > side2 && (side2 + side3) > side1) {
                numCorrectTriangles++;
                System.out.println(String.format("This is a correct triangle: %d + %d + %d", side1, side2, side3));
            }
        }
        System.out.println("--> Part 1: " + numCorrectTriangles);
    }
}
