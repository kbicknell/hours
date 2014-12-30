/**
 * 
 */
package hours;

import java.awt.Font;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Calendar;
import java.util.StringTokenizer;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JTextField;

/**
 * @author kbicknell
 * Represents a category of task for which time can be tracked 
 */
public class HoursCategory implements ActionListener {
  private String name;      // name of category
  private int ms;      // number of minutes put in to this category
  private long startTime;   // start time (in ms from 1900)
  private int index;        // index in the group
  public JButton inButton;
  public JLabel catLabel;
  public JLabel minLabel;
  public JTextField minTextField;
  private ImageIcon greyIcon = new ImageIcon("NSImage://gc_24");
  
  private ImageIcon greenIcon = new ImageIcon("NSImage://greenc_24");
  HoursGroup group;
  
  public void actionPerformed(ActionEvent e) {
    if (e.getActionCommand().equals("in")) {
      group.groupList.stopCurrentTask(false);
      this.startTime = Calendar.getInstance().getTimeInMillis();
      updateComponents();
      group.setCurrentTaskCategory(index);
    }
  }
  
  public HoursCategory(String name, int ms, long startTime, int index, HoursGroup group) {
    this.name = name;
    this.ms = ms;
    this.startTime = startTime;
    this.group = group;
    this.index = index;
    
    this.inButton = new JButton();
    inButton.addActionListener(this);
    
    this.catLabel = new JLabel();
    catLabel.setText(name);
    catLabel.setFont(new Font("Georgia", Font.PLAIN, 18));
    
    this.minLabel = new JLabel();
    minLabel.setFont(new Font("Georgia", Font.PLAIN, 18));
    
    this.minTextField = new JTextField(3);
    minTextField.setFont(new Font("Georgia", Font.PLAIN, 13));

    
    updateComponents();
  }
  
  /**
   * updates the gui components based on the new state
   */
  private void updateComponents() {
    if (this.startTime > 0) {
      inButton.setIcon(greenIcon);
      inButton.setActionCommand("nothing");
    } else {
      inButton.setIcon(greyIcon);
      inButton.setActionCommand("in");
    }

    int minutes = ms / 60 / 1000;
    if (ms > 0) {
      minLabel.setText(minutes / 60 + "." + minutes % 60);
      minTextField.setText(minutes / 60 + "." + minutes % 60);
    } else {
      minLabel.setText("");
      minTextField.setText("");
    }
    
  }
  
  public void stop() {
    int newms = (int) (Calendar.getInstance().getTimeInMillis() - this.startTime);
    this.ms += newms;
    group.groupList.addTime(newms);
    this.startTime = 0;
    updateComponents();
  }
  
  public boolean isActive() {
    return (startTime > 0);
  }
  
  public String name() {
    return(name);
  }
  
  public int ms() {
    return(ms);
  }
  
  public long startTime() {
    return(startTime);
  }
  
  public void switchToTextField() {
    GroupLayout thislayout = (GroupLayout) group.groupList.parentFrame.getContentPane().getLayout();
    thislayout.replace(minLabel, minTextField);
  }
  
  public void switchToLabel() {
    // figure out what text says
    String text = minTextField.getText();
    int hours;
    int minutes;

    if (text.isEmpty()) {
      hours = 0;
      minutes = 0;
    } else {
      StringTokenizer st = new StringTokenizer(text, ".");
      if (st.countTokens() != 2) {
        throw new RuntimeException("Invalid time entry: "+text);
      }
      hours = Integer.parseInt(st.nextToken());
      minutes = Integer.parseInt(st.nextToken());
    }
    int currentRawMinutes = ms / 60 / 1000;
    int currentHours = currentRawMinutes / 60;
    int currentMinutes = currentRawMinutes % 60;
    if ((currentHours != hours) || (currentMinutes != minutes)) {
      ms = (hours * 60 + minutes)*60*1000;
      updateComponents();
    }
    group.groupList.addTime(ms);
    GroupLayout thislayout = (GroupLayout) group.groupList.parentFrame.getContentPane().getLayout();
    thislayout.replace(minTextField, minLabel);
    
  }
  
  public void clearAll() {
    ms = 0;
    startTime = 0;
    updateComponents();
  }
}
