/**
 * 
 */
package hours;

import java.awt.Font;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.swing.JLabel;

/**
 * @author kbicknell
 *
 */
public class HoursGroupList {
  private Vector<HoursGroup> groups;
  Hours parentFrame;
  private int currentTaskGroup;
  static final private String dataFilename = "hours.data";
  static final private String backupFilename = "hours.data.backup";
  private String dataFilenamePath;
  private String backupFilenamePath;
  private int totalms;      // total time on all tasks (in milliseconds)
  public JLabel totalTimeLabel;
  
  public HoursGroupList(Hours parentFrame) {
    this.dataFilenamePath = new File(dataFilename).getAbsolutePath();
    this.backupFilenamePath = new File(backupFilename).getAbsolutePath();
    this.groups = new Vector<HoursGroup>();
    this.parentFrame = parentFrame;
    this.currentTaskGroup = -1;
    this.totalms = 0;
    this.totalTimeLabel = new JLabel();
    totalTimeLabel.setFont(new Font("Georgia", Font.PLAIN, 32));

    loadData();
  }

  private void loadData() {
    String line;
    
    BufferedReader reader;
    try {
      reader = new BufferedReader (new FileReader(dataFilenamePath));
      try {
        while ((line = reader.readLine()) != null) {
          StringTokenizer st = new StringTokenizer(line, "\t");
          if (st.countTokens() != 4) {
            throw new IOException("Corrupt data file: doesn't have 4 tokens per row");
          }
          String newGroup = st.nextToken();
          String newCategory = st.nextToken();
          int newms = Integer.parseInt(st.nextToken());
          Long newStartTime = Long.parseLong(st.nextToken());
          if (groups.isEmpty() || !groups.lastElement().name().equals(newGroup)) {
            groups.add(new HoursGroup(newGroup, groups.size(), this));
          }
          groups.lastElement().addCategory(newCategory, newms, newStartTime);
          if((newStartTime > 0) && (currentTaskGroup == -1)) {
            currentTaskGroup = groups.size()-1;
          } else if ((newStartTime > 0) && (currentTaskGroup > -1)){
            throw new IOException("Corrupt data file: has multiple events clocked in");
          }
          totalms += newms;
        }
        reader.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    writeData(backupFilenamePath, true);
    updateTotalTimeLabel();
  }
  
  private void updateTotalTimeLabel() {
    int minutes = totalms / 1000 / 60;
    totalTimeLabel.setText(minutes / 60 + "." + minutes % 60);
  }
  
  void writeData(String filename, boolean writeStartTimes) {
    BufferedWriter writer;
    try {
      writer = new BufferedWriter(new FileWriter(filename));
      for (HoursGroup g: groups) {
        for (HoursCategory c: g.categories()) {
          if (writeStartTimes) {
            writer.write(g.name()+"\t"+c.name()+"\t"+Integer.toString(c.ms())+"\t"+Long.toString(c.startTime())+"\n");
          } else {
            writer.write(g.name()+"\t"+c.name()+"\t"+Integer.toString(c.ms())+"\n");
          }
        }
      }
      writer.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  public boolean clockedIn() {
    return(currentTaskGroup > -1);
  }
  
  public Vector<HoursGroup> groups() {
    return(groups);
  }
  
  public void stopCurrentTask() {
    stopCurrentTask(true);
  }
  
  public void switchAllToTextField() {
    for (HoursGroup g: groups) {
      g.switchAllToTextField();
    }
  }
  
  public void switchAllToLabel() {
    totalms = 0;
    for (HoursGroup g: groups) {
      g.switchAllToLabel();
    }
    writeData(dataFilenamePath, true);
  }
  
  public void stopCurrentTask(boolean doWrite) {
    if (clockedIn()) {
      groups.get(currentTaskGroup).stopCurrentTask();
      currentTaskGroup = -1;
      if (doWrite) {
        writeData(dataFilenamePath, true);
      }
    }
  }
  
  public void clearAll() {
    for (HoursGroup g: groups) {
      g.clearAll();
    }
    totalms = 0;
    updateTotalTimeLabel();
    writeData(dataFilenamePath, true);
  }
  
  /** 
   * allows child tasks to add time to the parent's global clock 
   * @param ms
   */
  public void addTime(int ms) {
    totalms += ms;
    updateTotalTimeLabel();
  }
  
  void setCurrentTaskGroup(int index) {
    currentTaskGroup = index;
    parentFrame.stopButtonToStop();
    writeData(dataFilenamePath, true);
  }
}
