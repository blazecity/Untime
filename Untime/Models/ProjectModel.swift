//
//  ProjectCardModel.swift
//  Untime
//
//  Created by Jan Baumann on 05.12.21.
//

import Foundation

class ProjectModel: Identifiable, ObservableObject {
    var id: String {
        projectId
    }
    
    @Published var projectTitle: String
    @Published var tags: [TagModel]
    @Published var tasks: [TaskModel]
    @Published var projectId: String
    @Published var description: String
    @Published var active: Bool
    
    init() {
        self.projectTitle = ""
        self.projectId = ""
        self.description = ""
        self.tags = []
        self.tasks = []
        self.active = true
    }
    
    init(projectTitle: String, tags: [TagModel], tasks: [TaskModel], projectId: String, description: String) {
        self.projectTitle = projectTitle
        self.tags = tags
        self.tasks = tasks
        self.projectId = projectId
        self.description = description
        self.active = true
    }
    
    static func convertManagedProject(project: Project) -> ProjectModel {
        let newProjectModel = ProjectModel()
        
        guard let name = project.name else { return newProjectModel }
        guard let id = project.id else { return newProjectModel }
        guard let desc = project.desc else { return newProjectModel }
        guard let tags = project.tags else { return newProjectModel }
        guard let tasks = project.tasks else { return newProjectModel }
        
        newProjectModel.projectTitle = name
        newProjectModel.projectId = id
        newProjectModel.description = desc
        newProjectModel.active = project.active
        newProjectModel.tags = TagModel.getCollectionFromFetchingData(tags: tags)
        newProjectModel.tasks = TaskModel.getCollectionFromFetchingData(tasks: tasks)
        
        return newProjectModel
    }
}
