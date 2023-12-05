//
//  VideoCollectionViewController.swift
//  video-browser-demo
//
//  Created by Anastasia Yurok on 04.12.2023.
//

import UIKit

protocol VideoCollectionView: AnyObject {
  func setPreviews(_ previews: [VideoPreview])
}

class VideoCollectionViewController: UICollectionViewController, VideoCollectionView {
  @IBOutlet var progressView: UIView!
  
  var viewModel: VideoCollectionViewModel!

  private var displayedItems: [VideoPreview] = []
  private var lastFocusedIndexPath: IndexPath?
  
  // MARK: - Creation
  static func loadFromStoryboard() -> Self {
    let storyboard = UIStoryboard(
      name: "VideosCollection",
      bundle: Bundle(for: self.classForCoder())
    )
    return storyboard.instantiateViewController(identifier: "VideoCollectionViewController") as! Self
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = viewModel?.navigationTitle
    progressView.isHidden = false
    configureCollectionView()
    viewModel.onViewDidLoad()
  }
  
  // MARK: - VideoCollectionView
  func setPreviews(_ previews: [VideoPreview]) {
    displayedItems = previews
    
    progressView.isHidden = true
    collectionView.reloadData()
    collectionView.setNeedsFocusUpdate()
  }
  
  // MARK: - Private
  private func configureCollectionView() {
    collectionView.collectionViewLayout = createCollectionViewLayout()
    collectionView.allowsMultipleSelection = false
    collectionView.allowsFocus = true
    collectionView.remembersLastFocusedIndexPath = true
    restoresFocusAfterTransition = true
  }

  private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let fraction: CGFloat
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      fraction = 1 / 2
    default:
      fraction = 1 / 3
    }

    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(fraction),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: 10.0,
      leading: 8.0,
      bottom: 0.0,
      trailing: 8.0
    )

    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(fraction)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    // Section
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - UICollectionViewDataSource
extension VideoCollectionViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    displayedItems.count
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: VideoCollectionCell.identifier,
      for: indexPath
    ) as? VideoCollectionCell ?? VideoCollectionCell()
    
    // configured cell for displayed video
    let displayedItem = displayedItems[indexPath.row]
    cell.titleLabel.text = displayedItem.name
    cell.imageView.url = URL(string: displayedItem.imageUrl)
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension VideoCollectionViewController {
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    lastFocusedIndexPath = indexPath
    viewModel.onItemSelected(indexPath.row)
  }
  
  override func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
    return lastFocusedIndexPath
  }

  override func collectionView(
    _ collectionView: UICollectionView,
    didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
    with coordinator: UIFocusAnimationCoordinator
  ) {
    guard context.previouslyFocusedIndexPath != context.nextFocusedIndexPath else {
      return
    }
    
    lastFocusedIndexPath = context.nextFocusedIndexPath
    
    coordinator.addCoordinatedAnimations {
      if let indexPath = context.previouslyFocusedIndexPath {
        let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionCell
        cell?.updateFocused(false)
      }

      if let indexPath = context.nextFocusedIndexPath {
        let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionCell
        cell?.updateFocused(true)
      }
    }
  }
}
