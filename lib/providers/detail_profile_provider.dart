import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/job_position.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../constants/toast.dart';
import '../constants/url_api.dart';
import '../models/entity/certificate.dart';
import '../models/entity/profile_applicant.dart';
import '../models/entity/profile_applicant_skill.dart';
import '../models/entity/project.dart';
import '../models/entity/skill.dart';
import '../models/entity/skill_group.dart';
import '../models/entity/store_image.dart';
import '../models/entity/working_experience.dart';
import '../models/entity/working_style.dart';
import '../models/request/certificate_request.dart';
import '../models/request/profile_applicant_request.dart';
import '../models/request/profile_applicant_skill_request.dart';
import '../models/request/project_request.dart';
import '../models/request/store_image_request.dart';
import '../models/request/working_experience_request.dart';
import '../repositories/implement/album_images_implement.dart';
import '../repositories/implement/certificates_implement.dart';
import '../repositories/implement/job_positions_implement.dart';
import '../repositories/implement/profile_applicant_skills_implement.dart';
import '../repositories/implement/profile_applicants_implement.dart';
import '../repositories/implement/projects_implement.dart';
import '../repositories/implement/skill_groups_implement.dart';
import '../repositories/implement/skills_implement.dart';
import '../repositories/implement/working_experiences_implement.dart';
import '../repositories/implement/working_styles_implement.dart';
import '../shared/applicant_preferences.dart';
import '../views/bottom_tab_bar/bottom_tab_bar.dart';
import '../views/profile/detail_profile/new_profile_page.dart';
import '../views/profile/detail_profile/view_profile_page.dart';

class DetailProfileProvider with ChangeNotifier {
  List<ProfileApplicant> profileApplicants = [];
  bool isLoadListProfile = false;

  void getProfileApplicant() async {
    isLoadListProfile = true;
    var value = await ProfileApplicantsImplement().getProfileApplicantsById(
      UrlApi.profileApplicants,
      Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString(),
    );
    profileApplicants = value.data;
    isLoadListProfile = false;
    notifyListeners();
  }

  bool isLoading = false;
  List<StoreImage> listAlbumImage = [];
  List<StoreImage> listAlbumImageTmp = [];
  List<WorkingExperience> listWorkingExperience = [];
  List<WorkingExperience> listWorkingExperienceTmp = [];
  List<ProfileApplicantSkill> listProfileSkill = [];
  List<ProfileApplicantSkill> listProfileSkillTmp = [];
  List<Certificate> listCertificate = [];
  List<Certificate> listCertificateTmp = [];
  List<Project> listProject = [];
  List<Project> listProjectTmp = [];
  List<SkillGroup> skillGroups = [];
  List<JobPosition> listJobPosition = [];
  List<WorkingStyle> listWorkingStyle = [];

  void viewProfileById(String id) async {
    isLoading = true;
    notifyListeners();
    listSkillSearchUpdate(id);
    SkillGroupsImplement()
        .getSkillGroups(UrlApi.skillGroups)
        .then((value) => {skillGroups = value.data});
    notifyListeners();
    JobPositionsImplement()
        .getJobPositions(UrlApi.jobPositions)
        .then((value) => {listJobPosition = value.data});
    notifyListeners();
    WorkingStyleImplement()
        .getWorkingStyles(UrlApi.workingStyles)
        .then((value) => {listWorkingStyle = value.data});
    notifyListeners();
    await AlbumImagesImplement()
        .getAlbumImagesById(
          UrlApi.albumImages,
          "?profileApplicantId=",
          id,
        )
        .then((value) => {
              listAlbumImage = value.data,
            });
    notifyListeners();
    isLoading = false;
    notifyListeners();

    AlbumImagesImplement()
        .getAlbumImagesById(
          UrlApi.albumImages,
          "?profileApplicantId=",
          id,
        )
        .then((value) => {
              listAlbumImageTmp = value.data,
            });

    WorkingExperiencesImplement()
        .getWorkingExperiencesById(
          UrlApi.workingExperiences,
          id,
        )
        .then((value) => {
              listWorkingExperience = value.data,
            });
    notifyListeners();

    WorkingExperiencesImplement()
        .getWorkingExperiencesById(
          UrlApi.workingExperiences,
          id,
        )
        .then((value) => {
              listWorkingExperienceTmp = value.data,
            });

    ProfileApplicantSkillsImplement()
        .getProfileApplicantSkillsById(
          UrlApi.profileApplicantSkills,
          id,
        )
        .then((value) => {
              listProfileSkill = value.data,
              notifyListeners(),
            });
    notifyListeners();

    ProfileApplicantSkillsImplement()
        .getProfileApplicantSkillsById(
          UrlApi.profileApplicantSkills,
          id,
        )
        .then((value) => {
              listProfileSkillTmp = value.data,
            });

    CertificatesImplement()
        .getCertificatesById(
          UrlApi.certificates,
          id,
        )
        .then((value) => {
              listCertificate = value.data,
            });
    notifyListeners();

    CertificatesImplement()
        .getCertificatesById(
          UrlApi.certificates,
          id,
        )
        .then((value) => {
              listCertificateTmp = value.data,
            });

    ProjectsImplement()
        .getProjectsById(
          UrlApi.projects,
          id,
        )
        .then((value) => {
              listProject = value.data,
            });
    notifyListeners();

    ProjectsImplement()
        .getProjectsById(
          UrlApi.projects,
          id,
        )
        .then((value) => {
              listProjectTmp = value.data,
            });
  }

  List<Skill> listSkill = [];
  List<String> listSkillId = [];
  List<String> listProfileSkillId = [];
  List<Skill> listSkillSearch = [];
  List<String> listSkillIdSearch = [];

  void listSkillSearchUpdate(String id) async {
    await SkillsImplement().getSkills(UrlApi.skills).then((value) => {
          listSkill = value.data,
          if (listSkillId.isNotEmpty)
            {
              listSkillId.clear(),
            },
          for (var item in value.data) {listSkillId.add(item.id)}
        });

    await ProfileApplicantSkillsImplement()
        .getProfileApplicantSkillsById(
          UrlApi.profileApplicantSkills,
          id,
        )
        .then((value) => {
              if (listProfileSkillId.isNotEmpty)
                {
                  listProfileSkillId.clear(),
                },
              for (var item in value.data)
                {listProfileSkillId.add(item.skillId)}
            });

    listSkillIdSearch =
        listSkillId.toSet().difference(listProfileSkillId.toSet()).toList();

    if (listSkillSearch.isNotEmpty) {
      listSkillSearch.clear();
    }
    for (var item in listSkillIdSearch) {
      for (var i = 0; i < listSkill.length; i++) {
        if (item.contains(listSkill[i].id)) {
          listSkillSearch.add(listSkill[i]);
        }
      }
    }
    notifyListeners();
  }

  ProfileApplicant? detailProfile;
  TextEditingController controllerDescription = TextEditingController();

  void viewDetailProfile(BuildContext context, String id) async {
    await ProfileApplicantsImplement()
        .getProfileApplicantById(
          UrlApi.profileApplicants,
          id,
        )
        .then((value) => {
              detailProfile = value.data,
              controllerDescription.text = value.data!.description,
            });
    viewProfileById(id);
    listSkillSearchUpdate(id);
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewProfilePage();
    }));
  }

  Future<void> confirmListUpdate() async {
    // startAlbumImage
    for (var i = 0; i < listAlbumImage.length; i++) {
      if (listAlbumImage[i].id.length == 1) {
        createListAlbumImage.add(
          StoreImageRequest(
            id: '',
            profileApplicantId: listAlbumImage[i].profileApplicantId!,
            image: listAlbumImage[i].image!,
          ),
        );
      }
    }

    List<String> listAlbumImageIdTmp = [];
    List<String> listAlbumImageTmpId = [];

    for (var i = 0; i < listAlbumImage.length; i++) {
      listAlbumImageIdTmp.add(listAlbumImage[i].id);
    }

    for (var i = 0; i < listAlbumImageTmp.length; i++) {
      listAlbumImageTmpId.add(listAlbumImageTmp[i].id);
    }

    deleteListAlbumImage = listAlbumImageTmpId
        .toSet()
        .difference(listAlbumImageIdTmp.toSet())
        .toList();

    // endAlbumImage

    // startWorkingExperience
    for (var i = 0; i < listWorkingExperience.length; i++) {
      if (listWorkingExperience[i].id.isEmpty) {
        createListWorkExperience.add(WorkingExperienceRequest(
          profileApplicantId: listWorkingExperience[i].profileApplicantId,
          companyName: listWorkingExperience[i].companyName,
          startDate: listWorkingExperience[i].startDate,
          endDate: listWorkingExperience[i].endDate,
          jobPositionId: listWorkingExperience[i].jobPositionId,
        ));
      } else {
        updateListWorkExperience.add(
          WorkingExperience(
            id: listWorkingExperience[i].id,
            profileApplicantId: listWorkingExperience[i].profileApplicantId,
            companyName: listWorkingExperience[i].companyName,
            startDate: listWorkingExperience[i].startDate,
            endDate: listWorkingExperience[i].endDate,
            jobPositionId: listWorkingExperience[i].jobPositionId,
          ),
        );
      }
    }

    List<String> listWorkExperienceIdTmp = [];
    List<String> listWorkExperienceTmpId = [];

    for (var i = 0; i < listWorkingExperience.length; i++) {
      listWorkExperienceIdTmp.add(listWorkingExperience[i].id);
    }

    for (var i = 0; i < listWorkingExperienceTmp.length; i++) {
      listWorkExperienceTmpId.add(listWorkingExperienceTmp[i].id);
    }

    deleteListWorkExperience = listWorkExperienceTmpId
        .toSet()
        .difference(listWorkExperienceIdTmp.toSet())
        .toList();

    // endWorkingExperience

    // startSkill
    for (var i = 0; i < listProfileSkill.length; i++) {
      if (listProfileSkill[i].id.isEmpty) {
        createListProfileSkill.add(ProfileApplicantSkillRequest(
          profileApplicantId: listProfileSkill[i].profileApplicantId,
          skillId: listProfileSkill[i].skillId,
          skillLevel: listProfileSkill[i].skillLevel,
        ));
      } else {
        updateListProfileSkill.add(ProfileApplicantSkill(
          id: listProfileSkill[i].id,
          profileApplicantId: listProfileSkill[i].profileApplicantId,
          skillId: listProfileSkill[i].skillId,
          skillLevel: listProfileSkill[i].skillLevel,
        ));
      }
    }

    List<String> listProfileSkillIdTmp = [];
    List<String> listProfileSkillTmpId = [];

    for (var i = 0; i < listProfileSkill.length; i++) {
      listProfileSkillIdTmp.add(listProfileSkill[i].id);
    }

    for (var i = 0; i < listProfileSkillTmp.length; i++) {
      listProfileSkillTmpId.add(listProfileSkillTmp[i].id);
    }

    deleteListProfileSkill = listProfileSkillTmpId
        .toSet()
        .difference(listProfileSkillIdTmp.toSet())
        .toList();

    // endSkill

    // startCertificate
    for (var i = 0; i < listCertificate.length; i++) {
      if (listCertificate[i].id.isEmpty) {
        createListCertificate.add(CertificateRequest(
          name: listCertificate[i].name,
          skillGroupId: listCertificate[i].skillGroupId,
          profileApplicantId: listCertificate[i].profileApplicantId,
          grantDate: listCertificate[i].grantDate,
          expiryDate: listCertificate[i].expiryDate,
        ));
      } else {
        updateListCertificate.add(
          Certificate(
            id: listCertificate[i].id,
            name: listCertificate[i].name,
            skillGroupId: listCertificate[i].skillGroupId,
            profileApplicantId: listCertificate[i].profileApplicantId,
            grantDate: listCertificate[i].grantDate,
            expiryDate: listCertificate[i].expiryDate,
          ),
        );
      }
    }

    List<String> listCertificateIdTmp = [];
    List<String> listCertificateTmpId = [];

    for (var i = 0; i < listCertificate.length; i++) {
      listCertificateIdTmp.add(listCertificate[i].id);
    }

    for (var i = 0; i < listCertificateTmp.length; i++) {
      listCertificateTmpId.add(listCertificateTmp[i].id);
    }

    deleteListCertificate = listCertificateTmpId
        .toSet()
        .difference(listCertificateIdTmp.toSet())
        .toList();

    // endCertificate

    // startProject
    for (var i = 0; i < listProject.length; i++) {
      if (listProject[i].id.isEmpty) {
        createListProject.add(ProjectRequest(
          name: listProject[i].name,
          link: listProject[i].link,
          description: listProject[i].description,
          startTime: listProject[i].startTime,
          endTime: listProject[i].endTime,
          skill: listProject[i].skill,
          jobPosition: listProject[i].jobPosition,
          profileApplicantId: listProject[i].profileApplicantId,
        ));
      } else {
        updateListProject.add(
          Project(
            id: listProject[i].id,
            name: listProject[i].name,
            link: listProject[i].link,
            description: listProject[i].description,
            startTime: listProject[i].startTime,
            endTime: listProject[i].endTime,
            skill: listProject[i].skill,
            jobPosition: listProject[i].jobPosition,
            profileApplicantId: listProject[i].profileApplicantId,
          ),
        );
      }
    }

    List<String> listProjectIdTmp = [];
    List<String> listProjectTmpId = [];

    for (var i = 0; i < listProject.length; i++) {
      listProjectIdTmp.add(listProject[i].id);
    }

    for (var i = 0; i < listProjectTmp.length; i++) {
      listProjectTmpId.add(listProjectTmp[i].id);
    }

    deleteListProject =
        listProjectTmpId.toSet().difference(listProjectIdTmp.toSet()).toList();
    // endProject
  }

  List<StoreImageRequest> createListAlbumImage = [];
  List<String> deleteListAlbumImage = [];

  List<WorkingExperienceRequest> createListWorkExperience = [];
  List<WorkingExperience> updateListWorkExperience = [];
  List<String> deleteListWorkExperience = [];

  List<ProfileApplicantSkillRequest> createListProfileSkill = [];
  List<ProfileApplicantSkill> updateListProfileSkill = [];
  List<String> deleteListProfileSkill = [];

  List<CertificateRequest> createListCertificate = [];
  List<Certificate> updateListCertificate = [];
  List<String> deleteListCertificate = [];

  List<ProjectRequest> createListProject = [];
  List<Project> updateListProject = [];
  List<String> deleteListProject = [];

  String? education;
  String? githubLink;
  String? linkedInLink;
  String? facebookLink;
  String jobPositionId = '';
  String workingStyleId = '';
  bool? status;
  bool statusValue = false;

  void updateDetailProfile(
    String id,
    DateTime createDate,
    String education,
    String githubLink,
    String linkedInLink,
    String facebookLink,
    String jobPositionId,
    String workingStyleId,
    int status,
    context,
  ) async {
    ProfileApplicantsImplement().putProfileApplicant(
      UrlApi.profileApplicants,
      id,
      ProfileApplicant(
        id: id,
        createDate: createDate,
        applicantId:
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString(),
        description: controllerDescription.text,
        education: this.education ?? education,
        githubLink: this.githubLink ?? githubLink,
        linkedInLink: this.linkedInLink ?? linkedInLink,
        facebookLink: this.facebookLink ?? facebookLink,
        jobPositionId: this.jobPositionId,
        workingStyleId: this.workingStyleId,
        status: this.status! ? 0 : 1,
      ),
      ApplicantPreferences.getToken(''),
    ).then((value) => {
                                        Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => BottomTabBar(
                                                currentIndex: 3,
                                              )),
                                      (route) => false),
    });

    await confirmListUpdate();

    if (createListAlbumImage.isNotEmpty) {
      for (var i = 0; i < createListAlbumImage.length; i++) {
        AlbumImagesImplement().postAlbumImages(
          UrlApi.albumImages,
          createListAlbumImage[i].profileApplicantId,
          createListAlbumImage[i].image,
          ApplicantPreferences.getToken(''),
        );
      }
      createListAlbumImage.clear();
    }

    if (deleteListAlbumImage.isNotEmpty) {
      for (var i = 0; i < deleteListAlbumImage.length; i++) {
        AlbumImagesImplement().deleteAlbumImageById(
          UrlApi.albumImages,
          deleteListAlbumImage[i],
          ApplicantPreferences.getToken(''),
        );
      }
      deleteListAlbumImage.clear();
    }

    if (createListWorkExperience.isNotEmpty) {
      for (var i = 0; i < createListWorkExperience.length; i++) {
        WorkingExperiencesImplement().postWorkingExperience(
          UrlApi.workingExperiences,
          WorkingExperienceRequest(
            profileApplicantId: createListWorkExperience[i].profileApplicantId,
            companyName: createListWorkExperience[i].companyName,
            startDate: createListWorkExperience[i].startDate,
            endDate: createListWorkExperience[i].endDate,
            jobPositionId: createListWorkExperience[i].jobPositionId,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      createListWorkExperience.clear();
    }

    if (updateListWorkExperience.isNotEmpty) {
      for (var i = 0; i < updateListWorkExperience.length; i++) {
        WorkingExperiencesImplement().putWorkingExperienceById(
          UrlApi.workingExperiences,
          updateListWorkExperience[i].id,
          WorkingExperience(
            id: updateListWorkExperience[i].id,
            profileApplicantId: updateListWorkExperience[i].profileApplicantId,
            companyName: updateListWorkExperience[i].companyName,
            startDate: updateListWorkExperience[i].startDate,
            endDate: updateListWorkExperience[i].endDate,
            jobPositionId: updateListWorkExperience[i].jobPositionId,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      updateListWorkExperience.clear();
    }

    if (deleteListWorkExperience.isNotEmpty) {
      for (var i = 0; i < deleteListWorkExperience.length; i++) {
        WorkingExperiencesImplement().deleteWorkingExperienceById(
          UrlApi.workingExperiences,
          deleteListWorkExperience[i],
          ApplicantPreferences.getToken(''),
        );
      }
      deleteListWorkExperience.clear();
    }

    if (createListProfileSkill.isNotEmpty) {
      for (var i = 0; i < createListProfileSkill.length; i++) {
        ProfileApplicantSkillsImplement().postProfileApplicantSkill(
          UrlApi.profileApplicantSkills,
          ProfileApplicantSkillRequest(
            profileApplicantId: createListProfileSkill[i].profileApplicantId,
            skillId: createListProfileSkill[i].skillId,
            skillLevel: createListProfileSkill[i].skillLevel,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      createListProfileSkill.clear();
    }

    if (updateListProfileSkill.isNotEmpty) {
      for (var i = 0; i < updateListProfileSkill.length; i++) {
        ProfileApplicantSkillsImplement().putProfileApplicantSkillById(
          UrlApi.profileApplicantSkills,
          updateListProfileSkill[i].id,
          ProfileApplicantSkill(
            id: updateListProfileSkill[i].id,
            profileApplicantId: updateListProfileSkill[i].profileApplicantId,
            skillId: updateListProfileSkill[i].skillId,
            skillLevel: updateListProfileSkill[i].skillLevel,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      updateListProfileSkill.clear();
    }

    if (deleteListProfileSkill.isNotEmpty) {
      for (var i = 0; i < deleteListProfileSkill.length; i++) {
        ProfileApplicantSkillsImplement().deleteProfileApplicantSkillById(
          UrlApi.profileApplicantSkills,
          deleteListProfileSkill[i],
          ApplicantPreferences.getToken(''),
        );
      }
      deleteListProfileSkill.clear();
    }

    if (createListCertificate.isNotEmpty) {
      for (var i = 0; i < createListCertificate.length; i++) {
        CertificatesImplement().postCertificate(
          UrlApi.certificates,
          CertificateRequest(
            name: createListCertificate[i].name,
            skillGroupId: createListCertificate[i].skillGroupId,
            profileApplicantId: createListCertificate[i].profileApplicantId,
            grantDate: createListCertificate[i].grantDate,
            expiryDate: createListCertificate[i].expiryDate,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      createListCertificate.clear();
    }

    if (updateListCertificate.isNotEmpty) {
      for (var i = 0; i < updateListCertificate.length; i++) {
        CertificatesImplement().putCertificateById(
          UrlApi.certificates,
          updateListCertificate[i].id,
          Certificate(
            id: updateListCertificate[i].id,
            name: updateListCertificate[i].name,
            skillGroupId: updateListCertificate[i].skillGroupId,
            profileApplicantId: updateListCertificate[i].profileApplicantId,
            grantDate: updateListCertificate[i].grantDate,
            expiryDate: updateListCertificate[i].expiryDate,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      updateListCertificate.clear();
    }

    if (deleteListCertificate.isNotEmpty) {
      for (var i = 0; i < deleteListCertificate.length; i++) {
        CertificatesImplement().deleteCertificateById(
          UrlApi.certificates,
          deleteListCertificate[i],
          ApplicantPreferences.getToken(''),
        );
      }
      deleteListCertificate.clear();
    }

    if (createListProject.isNotEmpty) {
      for (var i = 0; i < createListProject.length; i++) {
        ProjectsImplement().postProject(
          UrlApi.projects,
          ProjectRequest(
            name: createListProject[i].name,
            link: createListProject[i].link,
            description: createListProject[i].description,
            startTime: createListProject[i].startTime,
            endTime: createListProject[i].endTime,
            skill: createListProject[i].skill,
            jobPosition: createListProject[i].jobPosition,
            profileApplicantId: createListProject[i].profileApplicantId,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      createListProject.clear();
    }

    if (updateListProject.isNotEmpty) {
      for (var i = 0; i < updateListProject.length; i++) {
        ProjectsImplement().putProjectById(
          UrlApi.projects,
          updateListProject[i].id,
          Project(
            id: updateListProject[i].id,
            name: updateListProject[i].name,
            link: updateListProject[i].link,
            description: updateListProject[i].description,
            startTime: updateListProject[i].startTime,
            endTime: updateListProject[i].endTime,
            skill: updateListProject[i].skill,
            jobPosition: updateListProject[i].jobPosition,
            profileApplicantId: updateListProject[i].profileApplicantId,
          ),
          ApplicantPreferences.getToken(''),
        );
      }
      updateListProject.clear();
    }

    if (deleteListProject.isNotEmpty) {
      for (var i = 0; i < deleteListProject.length; i++) {
        ProjectsImplement().deleteProjectById(
          UrlApi.projects,
          deleteListProject[i],
          ApplicantPreferences.getToken(''),
        );
      }
      deleteListProject.clear();
    }
  }

  ScrollController scrollController = ScrollController();

  scrollValidation() {
    scrollController.jumpTo(400);
  }

  void listSkillSearchNewProfile() async {
    await SkillsImplement().getSkills(UrlApi.skills).then((value) => {
          listSkill = value.data,
          if (listSkillId.isNotEmpty)
            {
              listSkillId.clear(),
            },
          for (var item in value.data) {listSkillId.add(item.id)}
        });

    listProfileSkillId = [];
    listSkillIdSearch =
        listSkillId.toSet().difference(listProfileSkillId.toSet()).toList();

    if (listSkillSearch.isNotEmpty) {
      listSkillSearch.clear();
    }
    for (var item in listSkillIdSearch) {
      for (var i = 0; i < listSkill.length; i++) {
        if (item.contains(listSkill[i].id)) {
          listSkillSearch.add(listSkill[i]);
        }
      }
    }
    notifyListeners();
  }

  void newProfileApplicant(BuildContext context, bool update) async {
    SkillGroupsImplement()
        .getSkillGroups(UrlApi.skillGroups)
        .then((value) => {skillGroups = value.data});
    notifyListeners();
    JobPositionsImplement()
        .getJobPositions(UrlApi.jobPositions)
        .then((value) => {listJobPosition = value.data});
    notifyListeners();
    WorkingStyleImplement()
        .getWorkingStyles(UrlApi.workingStyles)
        .then((value) => {listWorkingStyle = value.data});
    notifyListeners();
    listSkillSearchNewProfile();
    notifyListeners();

    detailProfile = ProfileApplicant(
      id: '',
      createDate: DateTime.now(),
      applicantId:
          Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString(),
      description: '',
      education: '',
      githubLink: '',
      linkedInLink: '',
      facebookLink: '',
      jobPositionId: '',
      workingStyleId: '',
      status: 1,
    );

    controllerDescription.text = '';
    listAlbumImage = [];
    listWorkingExperience = [];
    listProfileSkill = [];
    listCertificate = [];
    listProject = [];

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewProfilePage(
        update: update,
      );
    }));
  }

  void createProfileApplicant(BuildContext context, bool update) async {
    await ProfileApplicantsImplement()
        .postProfileApplicant(
          UrlApi.profileApplicants,
          ProfileApplicantRequest(
            applicantId: Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id']
                .toString(),
            description: controllerDescription.text,
            education: this.education ?? "",
            githubLink: this.githubLink ?? "",
            linkedInLink: this.linkedInLink ?? "",
            facebookLink: this.facebookLink ?? "",
            jobPositionId: this.jobPositionId,
            workingStyleId: this.workingStyleId,
            status: 0,
          ),
          ApplicantPreferences.getToken(''),
        )
        .then((value) => {
              notifyListeners(),
              if (listProfileSkill.isNotEmpty)
                {
                  for (var i = 0; i < listProfileSkill.length; i++)
                    {
                      ProfileApplicantSkillsImplement()
                          .postProfileApplicantSkill(
                        UrlApi.profileApplicantSkills,
                        ProfileApplicantSkillRequest(
                          profileApplicantId: value.data!.id,
                          skillId: listProfileSkill[i].skillId,
                          skillLevel: listProfileSkill[i].skillLevel,
                        ),
                        ApplicantPreferences.getToken(''),
                      ),
                    },
                },
              notifyListeners(),
              if (listAlbumImage.isNotEmpty)
                {
                  for (var i = 0; i < listAlbumImage.length; i++)
                    {
                      AlbumImagesImplement().postAlbumImages(
                        UrlApi.albumImages,
                        value.data!.id,
                        listAlbumImage[i].image!,
                        ApplicantPreferences.getToken(''),
                      ),
                    },
                },
              notifyListeners(),
              if (listCertificate.isNotEmpty)
                {
                  for (var i = 0; i < listCertificate.length; i++)
                    {
                      CertificatesImplement().postCertificate(
                        UrlApi.certificates,
                        CertificateRequest(
                          name: listCertificate[i].name,
                          skillGroupId: listCertificate[i].skillGroupId,
                          profileApplicantId: value.data!.id,
                          grantDate: listCertificate[i].grantDate,
                          expiryDate: listCertificate[i].expiryDate,
                        ),
                        ApplicantPreferences.getToken(''),
                      ),
                    },
                },
              notifyListeners(),
              if (listWorkingExperience.isNotEmpty)
                {
                  for (var i = 0; i < listWorkingExperience.length; i++)
                    {
                      WorkingExperiencesImplement().postWorkingExperience(
                        UrlApi.workingExperiences,
                        WorkingExperienceRequest(
                          profileApplicantId: value.data!.id,
                          companyName: listWorkingExperience[i].companyName,
                          startDate: listWorkingExperience[i].startDate,
                          endDate: listWorkingExperience[i].endDate,
                          jobPositionId: listWorkingExperience[i].jobPositionId,
                        ),
                        ApplicantPreferences.getToken(''),
                      ),
                    },
                },
              notifyListeners(),
              if (listProject.isNotEmpty)
                {
                  for (var i = 0; i < listProject.length; i++)
                    {
                      ProjectsImplement().postProject(
                        UrlApi.projects,
                        ProjectRequest(
                          name: listProject[i].name,
                          link: listProject[i].link,
                          description: listProject[i].description,
                          startTime: listProject[i].startTime,
                          endTime: listProject[i].endTime,
                          skill: listProject[i].skill,
                          jobPosition: listProject[i].jobPosition,
                          profileApplicantId: value.data!.id,
                        ),
                        ApplicantPreferences.getToken(''),
                      ),
                    },
                },
              notifyListeners(),
            });
    if (update) {
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => BottomTabBar(
                    currentIndex: 3,
                  )),
          (route) => false);
    } else {
      await ProfileApplicantsImplement()
          .getProfileApplicantsById(
            UrlApi.profileApplicants,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString(),
          )
          .then((value) async => {
                profileApplicants = value.data,
              });
      await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BottomTabBar()),
          (route) => false);
    }
    listProfileSkill.clear();
    listAlbumImage.clear();
    listCertificate.clear();
    listWorkingExperience.clear();
    listProject.clear();
    notifyListeners();
  }

  void deleteProfileById(
    BuildContext context,
    String id,
    DismissDirection direction,
  ) async {
    switch (direction) {
      case DismissDirection.endToStart:
        if (profileApplicants.length > 1) {
          ProfileApplicantsImplement().deleteProfileApplicantById(
            UrlApi.profileApplicants,
            id,
            ApplicantPreferences.getToken(''),
          );
          showToastSuccess("Xoá hồ sơ thành công");
          notifyListeners();
        } else {
          showToastFail(
              "Xoá không thành công \n Bạn phải có ít nhất một hồ sơ");
          getProfileApplicant();
          notifyListeners();
        }
        break;
      default:
        break;
    }
  }
}
