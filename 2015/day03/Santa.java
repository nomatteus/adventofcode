import java.io.*;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Arrays;

public class Santa {
  public int[] current = {0, 0};
  HashSet<List<Integer>> visitedCoords = new HashSet<>();

  public Santa(int startX, int startY) {
    current[0] = startX;
    current[1] = startY;
    addMove(current[0], current[1]);
  }

  public void move(char command) {
    switch(command) {
      case '^':
        current[0]++;
        break;
      case '>':
        current[1]++;
        break;
      case '<':
        current[1]--;
        break;
      case 'v':
        current[0]--;
        break;
      default:
        // invalid char.
        break;
    }
    addMove(current[0], current[1]);
  }

  private void addMove(int x, int y) {
    visitedCoords.add(Arrays.asList(new Integer(x), new Integer(y)));
  }

  public HashSet<List<Integer>> getVisitedCoords() {
    return visitedCoords;
  }

  // Run and print output for part1
  public static void part1() throws IOException {
    // Start at 0,0 (note that actual starting position is not important)
    Santa santa = new Santa(0, 0);

    BufferedReader buffer = buffReaderForFile("input");

    int c = 0;
    while((c = buffer.read()) != -1) {
      char character = (char) c;
      santa.move(character);
    }

    HashSet<List<Integer>> result = santa.getVisitedCoords();

    // Iterator<List<Integer>> iter = result.iterator();
    // while (iter.hasNext()) {
    //   List<Integer> coord = iter.next();
    //   System.out.println(String.format("visited: (%d,%d)", coord.get(0), coord.get(1)));
    // }
    System.out.println(String.format("     Total houses visited: %d", result.size()));

  }

  // part 2
  public static void part2() throws IOException {
    // Start at 0,0 (note that actual starting position is not important)
    Santa santa = new Santa(0, 0);
    Santa robotSanta = new Santa(0, 0);

    BufferedReader buffer = buffReaderForFile("input");

    int c = 0;
    int i = 0;
    while((c = buffer.read()) != -1) {
      char character = (char) c;
      // Take turns: santa moves first, then robot santa
      if (i % 2 == 0) {
        santa.move(character);
      } else {
        robotSanta.move(character);
      }
      i++;
    }

    HashSet<List<Integer>> result = santa.getVisitedCoords();
    HashSet<List<Integer>> resultRobotSanta = robotSanta.getVisitedCoords();

    // Add all robot's santa's coords to result, so we can get total houses visited.
    Iterator<List<Integer>> iter = resultRobotSanta.iterator();
    while (iter.hasNext()) {
      result.add(iter.next());
    }
    System.out.println(String.format("     Total houses visited: %d", result.size()));

  }

  public static BufferedReader buffReaderForFile(String filename) {
    FileReader fileReader = null;
    try {
      fileReader = new FileReader(filename);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    return new BufferedReader(fileReader);
  }

  public static void main(String[] args) throws IOException {
    System.out.println("----- Part 1");
    Santa.part1();
    System.out.println("----- Part 2");
    Santa.part2();
  }
}
