package vo;

public class Event {

	private int no;
	private String title;
	private String description;
	
	public Event() {}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "Event [no=" + no + ", title=" + title + ", description=" + description + "]";
	}
	
	
}
