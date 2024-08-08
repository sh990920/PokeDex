//
//  ViewController.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModel()
    private var pokemonList = [PokemonUrl]()
    private var pokemonImageList = [UIImage]()
    
    private let pokemonBall: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PokemonBall")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .darkRed
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSetting()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: "PokemonCell")
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .mainRed
        view.addSubview(pokemonBall)
        pokemonBall.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pokemonBall.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3 - 10
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }

    func dataSetting() {
        viewModel.pokemonSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] pokemonList in
            self?.pokemonList = pokemonList
            self?.collectionView.reloadData()
            
        }, onError: { error in
            print("데이터 바인딩 중 에러 발생")
        }).disposed(by: disposeBag)
        viewModel.pokemonImageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] pokemonImageList in
            self?.pokemonImageList = pokemonImageList
            self?.collectionView.reloadData()
        }, onError: { error in
            print("사진 바인딩 실패")
        }).disposed(by: disposeBag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.fetchNextPokemon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let image = pokemonImageList[indexPath.item]
        cell.setImage(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextViewController = DetailViewController()
        nextViewController.url = pokemonList[indexPath.item].url
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

}

