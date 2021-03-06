require_relative '../../test_helper'

feature "Running reports" do
  before :each do
    Capybara.current_driver = Capybara.javascript_driver
    sign_in_as 'Admin'

    @patients = (1 .. 3).map { FactoryGirl.create(:patient) }
    @treatment_area = FactoryGirl.create(:treatment_area)
    @patients.each do |patient|
      FactoryGirl.create(:patient_assignment, patient: patient,
                         treatment_area: @treatment_area)
    end
  end

  describe "Treatment Area Distribution" do
    test "should show the treatment area name" do
      visit admin_treatment_area_distribution_report_path

      within "#treatment_area_details" do
        assert_content @treatment_area.name
      end
    end

    test "should show each patient's name" do
      visit admin_treatment_area_distribution_report_path

      within "#treatment_area_details" do
        @patients.each do |patient|
          assert_content patient.full_name
        end
      end
    end

    test "should not show show empty treatment areas" do
      empty_treatment_area = FactoryGirl.create(:treatment_area)
      visit admin_treatment_area_distribution_report_path

      within "#treatment_area_details" do
        assert_no_content empty_treatment_area.name
      end
    end
  end

  describe "Post Clinic" do
    test "page loads" do
      visit admin_post_clinic_report_path
      assert_content "Post Clinic Report"
    end
  end

  describe "Clinic Summary" do
    test "page loads" do
      visit admin_clinic_summary_report_path
      assert_content "Clinic Summary Report"
    end
  end
end
