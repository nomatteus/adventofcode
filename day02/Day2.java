import java.io.*;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.util.Scanner;
import java.util.Arrays;

public class Day2 {

  public int sqFeetRequired(int l, int w, int h) {
    return 2*l*w + 2*w*h + 2*h*l + smallestSideArea(l, w, h);
  }

  public int smallestSideArea(int l, int w, int h) {
    int[] sides = {l, w, h};
    Arrays.sort(sides);
    return sides[0] * sides[1]; 
  }

  public static void main(String[] args) {
    Day2 day2 = new Day2();
    System.out.println(day2.sqFeetRequired(1, 1, 10));
    String input = null;
    try {
      input = new String(Files.readAllBytes(Paths.get("input")));
    } catch (IOException e) {
      e.printStackTrace();
    }
    Scanner scanner = new Scanner(input);
    int totalSqFt = 0;
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      String parts[] = line.split("x");
      totalSqFt += day2.sqFeetRequired(Integer.parseInt(parts[0]), Integer.parseInt(parts[1]), Integer.parseInt(parts[2]));
    } 
    System.out.println(String.format("Total Sq. Ft. Needed: %d", totalSqFt));
    scanner.close();
  }
}
